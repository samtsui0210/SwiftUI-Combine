//
//  MainView.swift
//  locationSwiftUI
//
//  Created by Sam Tsui on 26/1/2022.
//

import SwiftUI
import MapKit

struct MainView: View {
    
    @StateObject var router: MainViewRouter = MainViewRouter()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                
                switch router.currentPage{
                case .Home:
//                    HomeView()
                    router.homeView
                    Spacer()
                case .Map:
//                    MapControlView()
                    router.mapControlView
                        .environmentObject(LocationManager.shared)
                        .environmentObject(MapControlViewModel())
                }
                
                HStack(alignment: .center){
                    Spacer()
                    TabBarIcon(width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "map.fill", tabName: "Map") {
                        router.setPage(MainViewRouter.Page.Map)
                    }
                    Spacer()
                    MainButton(width: geometry.size.width/5, height: geometry.size.width, offSetY: -geometry.size.height/8/2){
                        router.setPage(MainViewRouter.Page.Home)
                    }
                    Spacer()
                    TabBarIcon(width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "waveform", tabName: "Interesting") {
                        router.setPage(MainViewRouter.Page.Home)
                    }
                    Spacer()
                }
                .frame(width: geometry.size.width ,height: geometry.size.height/8)
                .background(Color(.black)
                .shadow(radius: 2))
            }
            .ignoresSafeArea()
        }
    }
}

struct MainButton: View{
    
    let width, height, offSetY: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action){
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: width, height: height)
                    .shadow(radius: 4)
                Image(systemName: "house.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width-8 , height: height-8)
                    .foregroundColor(.black)
            }.offset(y: offSetY)
        }
    }
}

struct TabBarIcon: View {
    
    let width, height: CGFloat
    let systemIconName, tabName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action){
            VStack {
                Image(systemName: systemIconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                    .padding(.top, 10)
                    .foregroundColor(.white)
                Text(tabName)
                    .font(.footnote)
                    .foregroundColor(.white)
                Spacer()
            }
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
