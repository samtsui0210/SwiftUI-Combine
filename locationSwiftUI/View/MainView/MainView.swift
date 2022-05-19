//
//  MainView.swift
//  locationSwiftUI
//
//  Created by Sam Tsui on 26/1/2022.
//

import SwiftUI
import MapKit

struct MainView: View {
    
    @EnvironmentObject var router:MainViewRouter
    
    var body: some View {
        GeometryReader { geometry in
            
            let buttonW = geometry.size.width/5
            let buttonH = geometry.size.height/20
            
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
                        .environmentObject(MapControlViewModel.shared)
                case .Form:
                    if router.isNavigator{
                        NavHeader(topSafe: geometry.safeAreaInsets.top,
                                  width: geometry.size.width)
                    }
                    router.formView
                        .environmentObject(FormViewModel())

                }
                
                HStack(alignment: .center){
                    Spacer()
                    TabBarIcon(width: buttonW, height: buttonH, systemIconName: "map.fill", tabName: "Map") {
                        router.setPage(MainViewRouter.Page.Map)
                    }
                    Spacer()
                    MainButton(width: buttonW, height: geometry.size.height/7, offSetY: -geometry.size.height/8/2){
                        router.setPage(MainViewRouter.Page.Home)
                    }
                    Spacer()
                    TabBarIcon(width: buttonW, height: buttonH, systemIconName: "waveform", tabName: "Form Create") {
                        router.setPage(MainViewRouter.Page.Form)
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

struct NavHeader: View {
    
    let topSafe, width: CGFloat
    
    var body: some View{
        VStack(){
            HStack(spacing: 8){
                Button(action: {
                    print("button pressed")
                }) {
                    Image("back")
                }
                .frame(width: 30)
                Text("Title")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .font(Font.custom("PingFangTC-Semibold", size: 25))
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
                    .frame(width: 30)
            }
            .padding(EdgeInsets(top: 5 + topSafe, leading: 30, bottom: 20, trailing: 30))
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.black))
        }
    }
}

struct MainButton: View{
    
    let width, height, offSetY: CGFloat
    let action: () -> Void
    
    var body: some View {
        VStack(){
//            Spacer()
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
                }
            }
//            Spacer()
        }
        .offset(y: offSetY)
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
                    .padding(.top, 10)
                    .frame(width: width, height: height)
                    .foregroundColor(.white)
                Text(tabName)
                    .font(.footnote)
                    .foregroundColor(.white)
            }
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
