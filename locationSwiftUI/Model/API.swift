//
//  API.swift
//  locationSwiftUI
//
//  Created by TsuiWingLok on 19/11/2020.
//

import Foundation
import Alamofire

let NetworkManager = API()

let uploadManager: Session = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 30
    configuration.timeoutIntervalForResource = 30
    let manager = Alamofire.Session(configuration: configuration)
    return manager
}()

enum ParameterEncoding{
    case json
    case query
    case httpBody
}

class API{
    
    static let errJsonParameter = "errMsg"
    
    func getCountryPark(handler:ResponseHandler){
        let url = "https://geodata.gov.hk/gs/api/v1.0.0/geoDataQuery?q=%7Bv%3A%221%2E0%2E0%22%2Cid%3A%226bbc334b-cdb1-48ce-8a78-c58979327124%22%2Clang%3A%22ALL%22%7D"
        
        request(nil, url: url, handler: handler, method: .get)
        
//        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).response{ (res) in
//            let request = res.request
//            let response = res.response
//            let rawD = res.data
//            let error = res.error
//
//            if error != nil{
//                return handler.notifyFailure(.err_CONNECTION("err.msg.noInternetConnection"))
//            }
//            if response?.statusCode != 200{
//                return handler.notifyFailure(.err_STATUS_CODE_NOT_200("err.msg.loadingError"))
//            }
//            guard
//                let rawData = rawD
//                , let jsonAnyObj = try? JSONSerialization.jsonObject(with: rawData, options: [])
//                , let jsonObj = jsonAnyObj as? NSDictionary
//            else{
//                return handler.notifyFailure(.err_OTHERS("err.msg.loadingError"))
//            }
//            handler.handle([:], data: jsonObj)
//        }
        
    }
    
    func request(_ params:[String:AnyObject]?, url:String, handler:ResponseHandler, method:HTTPMethod = HTTPMethod.post, encoding: ParameterEncoding = .json, headers:[String:String] = [:], timeout:TimeInterval = 60){
        //        if !Helper.checkReachability(false){
        //            handler.notifyFailure(.err_NO_INTERNET_CONNECTION, errMsg:L("err.msg.noInternetConnection"))
        //            return nil
        //        }
        
        guard let urlComponent = URLComponents(string: url), let URI = urlComponent.url else{return }
        var request:URLRequest!
        
        let urlRequest = URLRequest(url: URI, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: timeout)
        
        switch encoding {
        case .json:
            request = urlRequest
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let params = params{
                request.httpBody = try? JSONSerialization.data(withJSONObject: params)
            }
            
        case .query:
            request = try? URLEncoding.default.encode(urlRequest, with: params)
        case .httpBody:
            request = try? URLEncoding.httpBody.encode(urlRequest, with: params)
        }
        
        request.httpMethod = method.rawValue
        
        headers.forEach { (key,value) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
         URLSession.shared.dataTask(with: request) { (data, response, error) in
             self.handleResponse(reqParams: params ?? [:], data: data, res: response, error: error, handler: handler)
         }.resume()
        
//        return AF.request(url, method: method, parameters: params, encoding: encoding).response{ (res) in
//            self.handleResponse(params: params, res: res, handler: handler)
//        }
    }
    
    func handleResponse(reqParams: [String:AnyObject], data: Data?, res: URLResponse?, error:Error?, handler:ResponseHandler){
        
        if let _ = error{
            handler.notifyFailure(.err_CONNECTION("err.msg.noInternetConnection"))
            return
        }
        
        let errMsg = data.flatMap({
            (try? JSONSerialization.jsonObject(with: $0, options: [])).flatMap({
                ($0 as? [String:Any])?[API.errJsonParameter] as? String
            })
        })
        
        if let statusCode = (res as? HTTPURLResponse)?.statusCode{
            if statusCode != 200{
                switch statusCode{
                case 400:
                    handler.notifyFailure(.err_STATUS_BARREQUEST(errMsg))
                case 401,403:
                    handler.notifyFailure(.err_STATUS_SESSIONEXPIRED(errMsg))
                case 500:
                    handler.notifyFailure(.err_STATUS_SERVERERROR(errMsg))
                default:
                    handler.notifyFailure(.err_STATUS_SERVERERROR(errMsg))
                }
            }else{
                if let rawData = data,
                   let jsonAnyObj = try? JSONSerialization.jsonObject(with: rawData, options: []),
                   let jsonObj = jsonAnyObj as? NSDictionary{
                    handler.handle(reqParams as NSDictionary, data: jsonObj)
                }else{
                    handler.notifyFailure(.err_OTHERS("err.msg.resNotJson"))
                }
            }
        }else{
            handler.notifyFailure(.err_STATUS_UNCAUGHTEXCEPTION)
        }
        
    }
    
    fileprivate func AFhandleResponse(params:[String:AnyObject], res: AFDataResponse<Data?>, handler:ResponseHandler){
        let request = res.request
        let response = res.response
        let rawD = res.data
        let error = res.error
        
        if error != nil{
            return handler.notifyFailure(.err_CONNECTION("err.msg.noInternetConnection"))
        }
        if response?.statusCode != 200{
            return handler.notifyFailure(.err_STATUS_CODE_NOT_200("err.msg.loadingError"))
        }
        guard
            let rawData = rawD
            , let jsonAnyObj = try? JSONSerialization.jsonObject(with: rawData, options: [])
            , let jsonObj = jsonAnyObj as? NSDictionary
        else{
            return handler.notifyFailure(.err_OTHERS("err.msg.loadingError"))
        }
        
        guard let status = jsonObj.object(forKey: "status") as? Int, status != 0 else{
            if let error_tchi = jsonObj.object(forKey: "error") as? String, let error_eng = jsonObj.object(forKey: "error_eng") as? String{
                return handler.notifyFailure(.err_STATUS_EQUALS_0("\(error_tchi) \(error_eng)"))
            }else{
                return handler.notifyFailure(.err_STATUS_EQUALS_0("err.msg.loadingError"))
            }
        }
        
        handler.handle(params as NSDictionary, data: jsonObj)
    }
    
    
}
