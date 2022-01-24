//
//  4234.swift
//  locationSwiftUI
//
//  Created by TsuiWingLok on 19/11/2020.
//

import Foundation
import MapKit

class CountryParkPointAnnotation: MKPointAnnotation{
    
    var nameChi: String
    var nameEng: String
    
    init(nameChi: String, nameEng: String){
        self.nameChi = nameChi
        self.nameEng = nameEng
    }
    
    static func fromJson(_ jsonData: NSDictionary) -> [CountryParkPointAnnotation]{
        var objList:[CountryParkPointAnnotation] = []
        
        if let features = jsonData["features"] as? [NSDictionary] {
            features.forEach({ (feature) in
                if let geometry = feature["geometry"] as? NSDictionary,
                   let coordinates = geometry["coordinates"] as? [CGFloat],
                   let props = feature["properties"] as? NSDictionary{
                    let obj = CountryParkPointAnnotation(nameChi: "", nameEng: "")
                    obj.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(coordinates[1]), longitude: CLLocationDegrees(coordinates[0]))
                    obj.title = props["Facility Name"] as? String ?? ""
                    objList.append(obj)
                }
            })
        }
        return objList
    }
    
}
