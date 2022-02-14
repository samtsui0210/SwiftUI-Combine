//
//  MapControlView.swift
//  LinkaSupport
//
//  Created by TsuiWingLok on 8/7/2020.
//

import SwiftUI
import MapKit

struct MapControlView:View{
    
    @State var centerCoordinate = CLLocationCoordinate2D()
    
    @EnvironmentObject var locationManger:LocationManager
    @EnvironmentObject var viewModel:MapControlViewModel
    
    @State private var showMenu:Bool = false
    
    let mapView = MapView()
    
    init(centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()) {
        self.centerCoordinate = centerCoordinate
        UITableView.appearance().backgroundColor = .clear
        UIScrollView.appearance().bounces = false
    }
    
    var dissmissKeyboardTap: some Gesture{
        TapGesture(count: 1)
            .onEnded { _ in
                UIApplication.shared.endEditing()
            }
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                mapView
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(0)
                
                VStack(spacing: 12){
                    Spacer()
                    if showMenu{
                        
                        HStack(spacing: 8){
                            Spacer()
                            Text("Refresh")
                            ControlBtn(contentView: Image(systemName: "arrow.clockwise")) {
                                self.viewModel.dispatch(.refreshMap)
                            }
                        }.animation(Animation.default.delay(0.2))
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                        
                        HStack(spacing: 8) {
                            Spacer()
                            Text("Country Park")
                            ControlBtn(contentView: Image(systemName: "leaf.arrow.circlepath")) {
                                self.viewModel.dispatch(.startCountryParkSearch)
                            }
                        }
                        .animation(Animation.default.delay(0.1))
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                        
                        HStack(spacing: 8) {
                            Spacer()
                            Text("Search")
                            ControlBtn(contentView: Image(systemName: "magnifyingglass")) {
                                self.viewModel.showControlPannel = true
                                self.viewModel.controlMenuType = .search
                                self.viewModel.searchText = ""
                            }
                        }
                        .animation(Animation.default)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                    }
                    
                    HStack {
                        Spacer()
                        MenuBtn(contentView: Image(systemName: "plus"), shouldRotate: self.showMenu) {
                            withAnimation(.spring(dampingFraction: 0.7)){
                                self.showMenu.toggle()
                            }
                        }
                    }
                    
                }
                .padding()
                .zIndex(1)
                
                if viewModel.showControlPannel{
                    ControlPannel()
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                        .gesture(self.dissmissKeyboardTap)
                        .edgesIgnoringSafeArea(.all)
                        .zIndex(2)
                }
                
                //            MapControlViewModel
                
                if viewModel.isLoading{
                    Color(UIColor.black.withAlphaComponent(0.5))
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                        .foregroundColor(.white)
                        .zIndex(3)
                }
                
                LeftSideMenu()
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
    
}

struct MapControlView_Previews: PreviewProvider {
    static var previews: some View {
        MapControlView(centerCoordinate: MKPointAnnotation.example.coordinate)
            .environmentObject(LocationManager.shared).environmentObject(MapControlViewModel.shared)
    }
}
