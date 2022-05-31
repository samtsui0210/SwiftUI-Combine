//
//  CommonResponseHandler.swift
//  locationSwiftUI
//
//  Created by TsuiWingLok on 19/11/2020.
//

import UIKit

class CommonResponseHandler: ResponseHandler{
    
    typealias CommonCallback = ( (_ success:Bool, _ error:APIErrors?) -> () )
    var callback:CommonCallback
    
    init(callback:@escaping CommonCallback) {
        self.callback = callback
    }
    
    func handle(_ requestData: NSDictionary, data: NSDictionary) {
        self.callback(true, nil)
    }
    
    func notifyFailure(_ error: APIErrors) {
        self.callback(false, error)
    }
    
    
}
