////
////  LocationManagerRxSwift-Combine.swift
////  locationSwiftUI
////
////  Created by TsuiWingLok on 17/1/2022.
////
//
//import Foundation
//import CoreLocation
//
//import RxSwift
//import RxRelay
//import RxCoreLocation
//
//// Combine + SwiftUI
//
//class LocationManager: NSObject, ObservableObject {
//    private let locationManager = CLLocationManager()
//    let disposeBag = DisposeBag()
//
//    // MARK:- Input
//
//    // MARK:- Output
//
//  @Published var status: CLAuthorizationStatus?
//    @Published var initLocation: CLLocation?
//  @Published var location: CLLocation?
//
//  override init() {
//    super.init()
//
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    self.locationManager.requestWhenInUseAuthorization()
//    self.locationManager.startUpdatingLocation()
//
//    self.locationManager.rx.status.subscribe(onNext:{ status in
//        self.status = status
//    })
//    .disposed(by: disposeBag)
//
//    self.locationManager.rx.didUpdateLocations
//        .withLatestFrom(locationManager.rx.location).subscribe(onNext: { location in
//        if let location = location{
//            self.location = location
//        }
//    })
//    .disposed(by: disposeBag)
//  }
//
//}
