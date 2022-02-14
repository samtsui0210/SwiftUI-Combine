//
//  ControlPannel.swift
//  locationSwiftUI
//
//  Created by TsuiWingLok on 17/1/2022.
//

import SwiftUI

enum ControlMenuType{
    case search
    case info
}

struct ControlPannel:View{
    
    @EnvironmentObject var viewModel:MapControlViewModel
    @EnvironmentObject var locationManger:LocationManager
    
    @State private var offset = CGSize.zero
    
    var body: some View{
        
        GeometryReader(content: { geometry in
            
            let dragGesture = DragGesture()
                .onChanged{ action in
                    
                    let updateTransHeight = self.offset.height + action.translation.height
                    
                    self.offset = (updateTransHeight <= 0) ?
                    CGSize(width: self.offset.width, height: 0) : CGSize(width: self.offset.width, height: updateTransHeight)
                }
                .onEnded{ action in
                    if self.offset.height > geometry.size.height / 2 + 32 {
                        withAnimation{
                            self.viewModel.showControlPannel = false
                        }
                        self.viewModel.searchText = ""
                        self.viewModel.annotaionURL = ""
                        
                    }else{
                        withAnimation{
                            self.offset = CGSize(width: self.offset.width, height: 0)
                        }
                    }
                }
            
            VStack{
                Spacer()
                    .frame(height: 32)
                VStack {
                    
                    HStack(alignment: .center){
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: geometry.size.width/3, height: 8)
                    }
                    .gesture(dragGesture)
                    .padding(12)
                    
                    MenuButtonView()
                    
                    switch viewModel.controlMenuType{
                    case .search:
                        SearchPannel(width: geometry.size.width)
                            .animation(Animation.default.delay(0.2))
                            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
                    case .info:
                        WebView(urlString: viewModel.annotaionURL)
                            .animation(Animation.default.delay(0.2))
                                                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                    }
                    
                    //                    Spacer()
                }
                .background(Color(UIColor.black.withAlphaComponent(0.5)))
                .cornerRadius(radius: 20, corners: [.topLeft, .topRight])
            }
            .offset(y: self.offset.height)
            .padding(.top, 20)
        })
    }
    
    
    struct MenuButtonView: View {
        
        @EnvironmentObject var viewModel:MapControlViewModel
        
        var body: some View{
            HStack{
                Button(action: {
                    viewModel.controlMenuType = .search
                            }) {
                                HStack {
                                    Image(systemName: "magnifyingglass.circle.fill")
                                        .foregroundColor(.white)
                                        .imageScale(.large)
                                    Text("SEARCH")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                }
                            }
                Spacer()
                Button(action: {
                    viewModel.controlMenuType = .info
                                            }) {
                                                HStack {
                                                    Image(systemName: "info.circle.fill")
                                                        .foregroundColor(.white)
                                                        .imageScale(.large)
                                                    Text("INFORMATION")
                                                        .foregroundColor(.white)
                                                        .font(.headline)
                                                }
                                            }
                
            }
            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
        }
    }
    
    struct SearchPannel: View{
        
        @EnvironmentObject var viewModel:MapControlViewModel
        
        let width: CGFloat
        
        var body: some View{
            HStack(alignment: .center){
                Button(action: {
                    
                }, label: {
                    Text("Search Location")
                        .foregroundColor(Color.white)
                })
                Spacer()
            }
            .padding([.leading, .trailing], 12)
            
            TextField("Type your search",text: $viewModel.searchText, onEditingChanged: { (changed) in
                //                        self.viewModel.searchText = self.searchText
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(8)
            
            Spacer()
                .frame(height: 0)
            
            ScrollView {
                SearchContent()
                    .frame(width: width)
            }
        }
    }
    
    struct SearchContent:View{
        
        @EnvironmentObject var viewModel:MapControlViewModel
        
        var body: some View{
            VStack{
                if viewModel.searchingNearby{
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }else{
                    let nearbyItems = viewModel.mapItems
                    if nearbyItems.count > 0{
                        ForEach(0..<nearbyItems.count){ index in
                            LazyVStack(alignment: .leading){
                                Button(action: {
                                    withAnimation{
                                        self.viewModel.showControlPannel = false
                                    }
                                    self.viewModel.searchText = ""
                                    self.viewModel.dispatch(.startRouteSearch(selectedMapItem: nearbyItems[index]))
                                }) {
                                    Text("\(nearbyItems[index].name ?? "")")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .foregroundColor(.black)
                                Divider()
                            }
                            .padding(8)
                            .background(Color.white)
                        }
                    }else{
                        Text("No Result")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

struct ControlPannel_Previews: PreviewProvider {
    static var previews: some View {
        ControlPannel()
            .environmentObject(LocationManager.shared).environmentObject(MapControlViewModel.shared)
    }
}
