//
//  CountryParkResponseHandler.swift
//  locationSwiftUI
//
//  Created by TsuiWingLok on 19/11/2020.
//

import UIKit

class CountryParkResponseHandler: ResponseHandler{
    
    typealias CountryParkCallback = ( (_ success:Bool, _ error:APIErrors?, _ data: [CountryParkPointAnnotation]) -> () )
    var callback:CountryParkCallback
    
    init(callback:@escaping CountryParkCallback) {
        self.callback = callback
    }
    
    func handle(_ requestData: NSDictionary, data: NSDictionary) {
        let annotations = CountryParkPointAnnotation.fromJson(data)
        self.callback(true, nil, annotations)
    }
    
    func notifyFailure(_ error: APIErrors) {
        self.callback(false, error, [])
    }
    
    
}
