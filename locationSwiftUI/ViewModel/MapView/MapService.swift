//
//  MapService.swift
//  locationSwiftUI
//
//  Created by TsuiWingLok on 19/1/2022.
//

import Combine
import MapKit

class MapService: NSObject {
    
    override init(){
        super.init()
    }
    
    func searchNearby(_ searchText: String) -> AnyPublisher<[MKMapItem], Error>{
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        let publisher = PassthroughSubject<[MKMapItem], Error>()
        
        let search = MKLocalSearch(request: request)
        search.start{ (response, error) in
            if let error = error{
                publisher.send(completion: .failure(error))
            }else{
                if let response = response{
                    publisher.send(response.mapItems)
                }else{
                    publisher.send([])
                }
            }
        }
        return publisher.eraseToAnyPublisher()
    }
    
    func getCountPark() -> AnyPublisher<[CountryParkPointAnnotation], APIErrors>{
        
        let publisher = PassthroughSubject<[CountryParkPointAnnotation], APIErrors>()
        
        NetworkManager.getCountryPark(handler: CountryParkResponseHandler(){ success, error, annotations in
            if success{
                publisher.send(annotations)
            }else{
                if let error = error{
                    publisher.send(completion: .failure(error))
                }else{
                    publisher.send([])
                }
            }
        })
        
        return publisher.eraseToAnyPublisher()
    }
    
    func directionCal(direction: MKDirections) -> AnyPublisher<[MKRoute], Error>{
        let publisher = PassthroughSubject<[MKRoute], Error>()
        
        direction.calculate{ (direct, err) in
            if let error = err {
                publisher.send(completion: .failure(error))
            }else{
                if let direct = direct{
                    publisher.send(direct.routes)
                }else{
                    publisher.send([])
                }
            }
        }
        return publisher.eraseToAnyPublisher()
    }
}
