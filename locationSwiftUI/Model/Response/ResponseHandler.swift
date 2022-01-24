//
//  ResponseHandler.swift
//  locationSwiftUI
//
//  Created by TsuiWingLok on 19/11/2020.
//

import UIKit

enum APIErrors: Error{
    case err_NO_INTERNET_CONNECTION// Reachbility return false
    case err_CONNECTION// timeout, worng domain
    case err_STATUS_CODE_NOT_200
    case err_STATUS_EQUALS_0
    case err_OTHERS// parse json etc.
}

protocol ResponseHandler{
    func handle(_ requestData:NSDictionary, data:NSDictionary)
    func notifyFailure(_ error:APIErrors, errMsg:String)
}
