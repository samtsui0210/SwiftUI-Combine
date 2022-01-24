//
//  ControlPannel.swift
//  locationSwiftUI
//
//  Created by TsuiWingLok on 17/1/2022.
//

import SwiftUI

struct ControlPannel:View{
    
    enum Menu{
        case search
        case nearby
        case none
    }
    
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
                            self.viewModel.showSearchList = false
                        }
                        self.viewModel.searchText = ""
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
                    
                    
                    HStack(alignment: .center){
                        Button(action: {
                            
                        }, label: {
                            Text("Search Location")
                                .foregroundColor(Color.white)
                        })
                        .padding(.bottom, 8)
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
                            .frame(width: geometry.size.width)
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
                                        self.viewModel.showSearchList = false
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
            .environmentObject(LocationManager()).environmentObject(MapControlViewModel())
    }
}
