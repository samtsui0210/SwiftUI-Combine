//
//  ResponseHandler.swift
//  locationSwiftUI
//
//  Created by TsuiWingLok on 19/11/2020.
//

import UIKit

enum APIErrors: Error{
    case err_NO_INTERNET_CONNECTION(_ msg:String?)// Reachbility return false
    case err_CONNECTION(_ msg:String?)// timeout, worng domain
    case err_STATUS_CODE_NOT_200(_ msg:String?)
    case err_STATUS_EQUALS_0(_ msg:String?)
    case err_STATUS_BARREQUEST(_ msg: String?)
    case err_STATUS_SESSIONEXPIRED(_ msg: String?)
    case err_STATUS_SERVERERROR(_ msg: String?)
    case err_OTHERS(_ msg:String?)// parse json etc.
    case err_STATUS_UNCAUGHTEXCEPTION
    
}

protocol ResponseHandler{
    func handle(_ requestData:NSDictionary, data:NSDictionary)
    func notifyFailure(_ error:APIErrors)
}

