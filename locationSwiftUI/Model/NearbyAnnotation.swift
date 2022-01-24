//
//  NearbyAnnotation.swift
//  LinkaSupport
//
//  Created by TsuiWingLok on 9/7/2020.
//

import Foundation
import MapKit

class NearbyAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String? = "", subtitle: String? = ""){
        self.coordinate = coordinate
        self.title = title
    }
    
}
