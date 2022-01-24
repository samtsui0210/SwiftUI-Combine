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

class API{
    
    func getCountryPark(handler:ResponseHandler){
        let url = "https://geodata.gov.hk/gs/api/v1.0.0/geoDataQuery?q=%7Bv%3A%221%2E0%2E0%22%2Cid%3A%226bbc334b-cdb1-48ce-8a78-c58979327124%22%2Clang%3A%22ALL%22%7D"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).response{ (res) in
            let request = res.request
            let response = res.response
            let rawD = res.data
            let error = res.error
            
            if error != nil{
                return handler.notifyFailure(.err_CONNECTION, errMsg:"err.msg.noInternetConnection")
            }
            if response?.statusCode != 200{
                return handler.notifyFailure(.err_STATUS_CODE_NOT_200, errMsg:"err.msg.loadingError")
            }
            guard
                let rawData = rawD
                , let jsonAnyObj = try? JSONSerialization.jsonObject(with: rawData, options: [])
                , let jsonObj = jsonAnyObj as? NSDictionary
            else{
                return handler.notifyFailure(.err_OTHERS,errMsg:"err.msg.loadingError")
            }
            handler.handle([:], data: jsonObj)
        }
        
    }
    
    fileprivate func request(_ params:[String:AnyObject], url:String, handler:ResponseHandler, method:HTTPMethod = HTTPMethod.post, encoding: ParameterEncoding = JSONEncoding.default)->Request?{
        //        if !Helper.checkReachability(false){
        //            handler.notifyFailure(.err_NO_INTERNET_CONNECTION, errMsg:L("err.msg.noInternetConnection"))
        //            return nil
        //        }
        
        return AF.request(url, method: method, parameters: params, encoding: encoding).response{ (res) in
            self.handleResponse(params: params, res: res, handler: handler)
        }
    }
    
    fileprivate func handleResponse(params:[String:AnyObject], res: AFDataResponse<Data?>, handler:ResponseHandler){
        let request = res.request
        let response = res.response
        let rawD = res.data
        let error = res.error
        
        if error != nil{
            return handler.notifyFailure(.err_CONNECTION, errMsg:"err.msg.noInternetConnection")
        }
        if response?.statusCode != 200{
            return handler.notifyFailure(.err_STATUS_CODE_NOT_200, errMsg:"err.msg.loadingError")
        }
        guard
            let rawData = rawD
            , let jsonAnyObj = try? JSONSerialization.jsonObject(with: rawData, options: [])
            , let jsonObj = jsonAnyObj as? NSDictionary
        else{
            return handler.notifyFailure(.err_OTHERS,errMsg:"err.msg.loadingError")
        }
        
        guard let status = jsonObj.object(forKey: "status") as? Int, status != 0 else{
            if let error_tchi = jsonObj.object(forKey: "error") as? String, let error_eng = jsonObj.object(forKey: "error_eng") as? String{
                return handler.notifyFailure(.err_STATUS_EQUALS_0, errMsg: "\(error_tchi) \(error_eng)")
            }else{
                return handler.notifyFailure(.err_STATUS_EQUALS_0, errMsg:"err.msg.loadingError")
            }
        }
        
        handler.handle(params as NSDictionary, data: jsonObj)
    }
    
    
}
