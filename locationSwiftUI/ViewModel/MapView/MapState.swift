//
//  MapReducer.swift
//  locationSwiftUI
//
//  Created by TsuiWingLok on 2/11/2020.
//

import Foundation
import MapKit

protocol MapState{}

extension MapControlViewModel{
    
    struct Idle: MapState{}
    
    struct NearbyState: MapState{
        
        var searching: NearbySearch
        
        enum NearbySearch{
            case searching
            case result(mapItems:[MKMapItem])
            case fail
        }
    }
    
    struct RouteSearchState: MapState{
        
        var searching: RouteSearch
        
        enum RouteSearch{
            case searching(selectedMapItem: MKMapItem)
            case result(placemark: MKPlacemark)
            case fail
        }
    }
    
    struct CountryParkState: MapState{
        
        var searching: CountryParkSearch
        
        enum CountryParkSearch{
            case searching
            case result(annotations:[CountryParkPointAnnotation])
            case fail
        }
    }
    
}


//func mapReducer(state: MapState, action: MapAction) -> MapState{
//    switch action{
//    case let mapAction as searchAction:
//        print(mapAction.searchText)
//        return .loading
//    case let mapAction as getParkActin:
//        return .loading
//    case let mapAction as refreshAction:
//        print(mapAction.text)
//        return .loading
//    default:
//        return state
//    }
//}
