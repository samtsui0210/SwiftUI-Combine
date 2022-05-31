//
//  NavigationView.swift
//  locationSwiftUI
//
//  Created by TsuiWingLok on 18/11/2020.
//

import SwiftUI

struct CustomNavView<Content: View>: View {
    
    var contentView:Content
    var isFullScreen:Bool = false
    var backAction = {}
    
    var body: some View {
        ZStack {
            VStack{
//                if !isFullScreen{Spacer().frame(height: 50)}
                contentView
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                HStack {
                    NavBackBtn(contentView: Image(systemName: "arrow.left")){
                        backAction()
                    }
                }
                .padding(0)
                Spacer()
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .padding(.top, 0)
    }
    
}
