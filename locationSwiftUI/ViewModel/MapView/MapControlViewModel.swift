//
//  MapControlViewModel.swift
//  LinkaSupport
//
//  Created by TsuiWingLok on 8/7/2020.
//

import Foundation
import MapKit
import Combine

class MapControlViewModel: ObservableObject {
    
    static let shared = MapControlViewModel()
    
    @Published var showControlPannel: Bool = false
    
    @Published var searchText: String = ""
    
    @Published var annotations:[MKPointAnnotation] = []
    
    @Published private(set) var state: MapState = Idle()
    
    @Published var isLoading:Bool = false
    
    @Published var searchingNearby:Bool = false
    @Published var mapItems:[MKMapItem] = []
    
    @Published var annotaionURL:String = ""
    @Published var controlMenuType: ControlMenuType = .search
    
    enum Event {
        case refreshMap
        case startRouteSearch(selectedMapItem: MKMapItem)
        case completeRouteSearch(placemark: MKPlacemark)
        case startNearbySearch
        case completeNearbySearch(result:Bool, mapItems:[MKMapItem])
        case startCountryParkSearch
        case completeCountryParkSearch(result:Bool, annotations:[CountryParkPointAnnotation])
    }
    
    private let searchResult: [String] = []
    
    private var countryParkPointAnnotation:[CountryParkPointAnnotation] = []
    
    private var subscription: Set<AnyCancellable> = []
    
    private let mapService = MapService()
    
    init(){
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
                        .removeDuplicates()
                        .map({ (string) -> String? in
                            return string
                        })
                        .compactMap{ $0 }
                        .sink { (_) in
                        } receiveValue: { [self] (searchField) in
                            if searchField != ""{
//                                self.searchNearby()
                                self.state = self.reducer(.startNearbySearch)
                            }
                        }.store(in: &subscription)
        
    }
    
    //MARK:- State Management
    
    func reducer(_ event: Event) -> MapState{
        switch event{
        case .refreshMap:
            self.refreshMap()
            return Idle()
        case .startRouteSearch(let item):
            isLoading = true
            return RouteSearchState(searching: .searching(selectedMapItem: item))
        case .completeRouteSearch(let placemark):
            isLoading = false
            return RouteSearchState(searching: .result(placemark: placemark))
        case .startNearbySearch:
            self.searchNearby()
            return NearbyState(searching: .searching)
        case .completeNearbySearch(let result, let mapItems):
            return result ? NearbyState(searching: .result(mapItems: mapItems)) : Idle()
        case .startCountryParkSearch:
            isLoading = true
            self.getCountPark()
            return CountryParkState(searching: .searching)
        case .completeCountryParkSearch(let result, let annotations):
            isLoading = false
            return result ? CountryParkState(searching: .result(annotations: annotations)) : Idle()
        }
    }

    func dispatch(_ event: Event){
        DispatchQueue.main.async {
            print("state : \(self.state) \n event : \(event) \n")
            self.state = self.reducer(event)
        }
    }
    
    private func refreshMap(){
        countryParkPointAnnotation.removeAll()
    }
    
    //MARK:- Map Function
    
    func searchNearby(){
        self.mapItems = []
        searchingNearby = true
        mapService.searchNearby(searchText)
            .receive(on: DispatchQueue.main)
            .sink{ completion in
                self.searchingNearby = false
                switch completion {
                case .failure(_):
                    self.dispatch(.completeNearbySearch(result: false, mapItems: []))
                case .finished: break
                }
            } receiveValue: { mapItems in
                self.searchingNearby = false
                self.mapItems = mapItems
                self.dispatch(.completeNearbySearch(result: true, mapItems: mapItems))
            }
            .store(in: &subscription)
    }
    
    private func getCountPark(){
        mapService.getCountPark()
            .receive(on: DispatchQueue.main)
            .sink{ completion in
                switch completion {
                case .failure(_):
                    self.dispatch(.completeCountryParkSearch(result: false, annotations: []))
                case .finished: break
                }
            } receiveValue: { annotations in
                self.dispatch(.completeCountryParkSearch(result: true, annotations: annotations))
                self.countryParkPointAnnotation = annotations
            }
            .store(in: &subscription)
    }
    
    func searchForRoute(mapView: MKMapView, location: CLLocation, placemark: MKPlacemark){
        
        let destination = CLLocation(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
        let destLocation = CLLocationCoordinate2D(latitude: destination.coordinate.latitude, longitude: destination.coordinate.longitude)
        
        let req = MKDirections.Request()
        let currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        req.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation))
        req.destination = MKMapItem(placemark: MKPlacemark(coordinate: destLocation))
        req.transportType = .walking
        let direction = MKDirections(request: req)
        drawPolyline(mapView: mapView, direction: direction, destLocation: destLocation, placemark: placemark)
        
    }
    
    func drawPolyline(mapView: MKMapView, direction:MKDirections, destLocation: CLLocationCoordinate2D, placemark: MKPlacemark){
        mapService.directionCal(direction: direction)
            .receive(on: DispatchQueue.main)
            .sink{ completion in
                switch completion {
                case .failure(_):
                    return
                case .finished: break
                }
            } receiveValue: { routes in
                if let polyline = routes.first?.polyline{
                    mapView.removeOverlays(mapView.overlays)
                    mapView.addOverlay(polyline)
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    let region =  MKCoordinateRegion(center: destLocation, span: span)
                    mapView.setRegion(region, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = placemark.title
                    annotation.coordinate = placemark.coordinate
                    mapView.addAnnotation(annotation)
                    
                    
                    
                    self.dispatch(.completeRouteSearch(placemark: placemark))
                }
            }
            .store(in: &subscription)
    }
    
    func updateControlMenuTpye(_ controlMenuType: ControlMenuType){
        self.controlMenuType = controlMenuType
    }
    
    func mapViewSnapshot(mapView: MKMapView){
        let mapSnapshotOptions = MKMapSnapshotter.Options()
        mapSnapshotOptions.region = mapView.region
        mapSnapshotOptions.scale = UIScreen.main.scale
        mapSnapshotOptions.size = mapView.frame.size
        mapSnapshotOptions.showsBuildings = true
//        mapSnapshotOptions.showsPointsOfInterest = true
        
        mapSnapshotOptions.pointOfInterestFilter = .includingAll

        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        snapShotter.start { (snap, error) in
            if let image = snap?.image{
                LocalStorage.saveMapSnapshot(image: image)
            }
        }
    }
    
}
