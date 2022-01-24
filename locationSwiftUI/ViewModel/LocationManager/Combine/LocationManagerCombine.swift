////
////  LocationManager.swift
////  LinkaSupport
////
////  Created by TsuiWingLok on 9/7/2020.
////
//
//import Foundation
//import CoreLocation
//
//import Combine
//
//// Combine
//
//enum LocationError: Error {
//    case unauthorized
//    case unableToDetermineLocation
//}
//
//class LocationManager: NSObject, ObservableObject {
//
//    private var cancellables = Set<AnyCancellable>()
//    private let locationService = LocationService()
//
//    @Published var initLocation: CLLocation?
//    @Published private(set) var status: CLAuthorizationStatus?
//    @Published private(set) var isLoading: Bool = false
//    @Published private(set) var location: CLLocation?
//    @Published private(set) var locationError: LocationError?
//
//    override init() {
//        super.init()
//        fetchLocation()
//    }
//
//    func fetchLocation() {
//        isLoading = true
//
//        locationService.requestWhenInUseAuthorization()
//            .flatMap { self.locationService.requestLocation() }
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//                if case .failure(let error) = completion {
//                    self.locationError = error
//                }
//                self.isLoading = false
//            } receiveValue: { location in
//                self.location = location
//            }
//            .store(in: &cancellables)
//    }
//
//}
//
//class LocationService: NSObject {
//
//    private let locationManager = CLLocationManager()
//
//    private var authorizationRequests: [(Result<Void, LocationError>) -> Void] = []
//    private var locationRequests: [(Result<CLLocation, LocationError>) -> Void] = []
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//    }
//
//    func requestWhenInUseAuthorization() -> Future<Void, LocationError> {
//        guard locationManager.authorizationStatus == .notDetermined else {
//            return Future { $0(.success(())) }
//        }
//
//        let future = Future<Void, LocationError> { completion in
//            self.authorizationRequests.append(completion)
//        }
//
//        locationManager.requestWhenInUseAuthorization()
//
//        return future
//    }
//
//    func requestLocation() -> Future<CLLocation, LocationError> {
//
//        guard locationManager.authorizationStatus == .authorizedAlways ||
//                locationManager.authorizationStatus == .authorizedWhenInUse
//        else {
//            return Future { $0(.failure(LocationError.unauthorized)) }
//        }
//
//        let future = Future<CLLocation, LocationError> { completion in
//            self.locationRequests.append(completion)
//        }
//
//        locationManager.requestLocation()
//
//        return future
//    }
//
//    private func handleLocationRequestResult(_ result: Result<CLLocation, LocationError>) {
//        while locationRequests.count > 0 {
//            let request = locationRequests.removeFirst()
//            request(result)
//        }
//    }
//}
//
//extension LocationService: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        let locationError: LocationError
//        if let error = error as? CLError, error.code == .denied {
//            locationError = .unauthorized
//        } else {
//            locationError = .unableToDetermineLocation
//        }
//        handleLocationRequestResult(.failure(locationError))
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            handleLocationRequestResult(.success(location))
//        }
//    }
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        while authorizationRequests.count > 0 {
//            let request = authorizationRequests.removeFirst()
//            request(.success(()))
//        }
//    }
//}
