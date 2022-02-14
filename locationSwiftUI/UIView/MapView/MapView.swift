//
//  MapView.swift
//  LinkaSupport
//
//  Created by TsuiWingLok on 8/7/2020.
//

import Foundation
import UIKit
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    typealias Context = UIViewRepresentableContext<Self>
    
    @EnvironmentObject var locationManger:LocationManager
    @EnvironmentObject var viewModel:MapControlViewModel
    
    static private var mapViews = [MKMapView]()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        
        if let curMapView = MapView.mapViews.first{
            return curMapView
        }else{
            let mapView = MKMapView(frame: .zero)
            mapView.delegate = context.coordinator
            mapView.showsUserLocation = true
            mapView.layoutMargins = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 8)
            MapView.mapViews = [mapView]
            return mapView
        }
    }
    
    func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
        if let _ = locationManger.initLocation{
            
            viewModel.mapViewSnapshot(mapView: view)
            
//            if let location = locationManger.location{
//                let location2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//                let region =  MKCoordinateRegion(center: location2D, span: span)
//                view.setRegion(region, animated: true)
//            }
            
            switch self.viewModel.state{
            case let state as MapControlViewModel.RouteSearchState:
                if case .searching(let selectedMapItem) = state.searching{
                    if let location = locationManger.location{
                        let placemark = selectedMapItem.placemark
                        viewModel.searchForRoute(mapView: view, location: location, placemark: placemark)
                    }
                }
            case let state as MapControlViewModel.Idle:
                view.removeOverlays(view.overlays)
            default:
                print("")
            }
        }else{
            if let location = locationManger.location{
                locationManger.initLocation = location
                let location2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region =  MKCoordinateRegion(center: location2D, span: span)
                view.setRegion(region, animated: false)
            }
        }
        
        //        view.removeAnnotations(view.annotations)
        //        view.addAnnotations(self.viewModel.annotations)
        
        switch viewModel.state{
            
        case let state as MapControlViewModel.CountryParkState:
            if case .result(let annotations) = state.searching{
                view.removeAnnotations(view.annotations)
                view.addAnnotations(annotations)
            }
        case let state as MapControlViewModel.RouteSearchState:
            if case .result(let placemark) = state.searching{
                let annotation = MKPointAnnotation()
                annotation.title = placemark.title
                annotation.coordinate = placemark.coordinate
                view.addAnnotation(annotation)
            }
        default:
            view.removeAnnotations(view.annotations)
        }
        
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
            
            switch parent.viewModel.state{
            case let state as MapControlViewModel.CountryParkState:
                if case .result(let annotations) = state.searching{
                    annotations.forEach { annotaion in
                        
                        if let mapAnnotation = view.annotation{
                            if mapAnnotation.isEqual(annotaion){
                                guard let url = URL(string: annotaion.webSite) else { return }
//                                UIApplication.shared.open(url)
                                parent.viewModel.annotaionURL = annotaion.webSite
                                parent.viewModel.showControlPannel = true
                                parent.viewModel.controlMenuType = .info
                            }
                        }
                    }
                }
            default:
                return
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .red
            renderer.lineWidth = 4.0
            return renderer
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            return nil
            
            let reuseIdentifier = "pin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
            if annotation as! NSObject != mapView.userLocation{
                return nil
            }
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            annotationView?.image = UIImage(systemName: "mappin.and.ellipse")
            
            return annotationView
        }
        
    }
    
}

extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
}

extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension MKAnnotation{
    func isEqual (_ annotation: MKAnnotation) -> Bool {
        return (self.coordinate.latitude == annotation.coordinate.latitude && self.coordinate.longitude == annotation.coordinate.longitude)
    }
}
