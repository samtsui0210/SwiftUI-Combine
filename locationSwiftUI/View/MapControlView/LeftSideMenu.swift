//
//  LeftSideMenu.swift
//  locationSwiftUI
//
//  Created by TsuiWingLok on 17/1/2022.
//

import SwiftUI

struct LeftSideMenu:View{
    
    @EnvironmentObject var viewModel:MapControlViewModel
    
    @State private var showSideMenu:Bool = false
    @State private var offset:CGSize = CGSize.zero
    
    var body: some View{
        GeometryReader(content: { geometry in
            
            let dragGesture = DragGesture()
                .onChanged{ action in
                    
                    let updateTransWidth = self.offset.width + action.translation.width
                    
                    self.offset = (updateTransWidth >= 0) ?
                        CGSize(width: 0, height: self.offset.height) : CGSize(width: updateTransWidth, height: self.offset.height)
                }
                .onEnded{ action in
                    if self.offset.width < -geometry.size.width/4 {
                        withAnimation{
                            self.offset = CGSize(width: -geometry.size.width/2, height: self.offset.height)
                            self.showSideMenu.toggle()
                        }
                    }else{
                        withAnimation{
                            self.offset = CGSize(width: 0, height: self.offset.height)
                        }
                    }
                }
            
            VStack{
                HStack(alignment: .top, spacing: 0){
                    SideMenu(topSafeArea: geometry.safeAreaInsets.top)
                        .frame(width: geometry.size.width/2)
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
                        .gesture(dragGesture)
                        .zIndex(4)
                    SideMenuBtn(contentView:
                                    Image(systemName: self.showSideMenu ?  "arrow.left" : "arrow.right")){
                        self.showSideMenu.toggle()
                        self.offset = CGSize(
                            width: self.showSideMenu ? 0 : -geometry.size.width/2,
                            height: self.offset.height)
                    }
                    .padding(.top, 50)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .offset(x: self.showSideMenu ? self.offset.width : -geometry.size.width/2)
            
        })
    }
}
