//
//  Button.swift
//  locationSwiftUI
//
//  Created by TsuiWingLok on 17/11/2020.
//

import SwiftUI

struct ControlBtn<Content: View>:View{
    var contentView:Content
    var action = {}
    var bg:some View = Color.black.opacity(0.75)
    var fgColor:Color = Color.white
    var font:Font = .title
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.action()
            }
        }) {
            contentView
        }
        .padding()
        .background(bg)
        .foregroundColor(fgColor)
        .font(font)
        .clipShape(Circle())
    }
}

struct MenuBtn<Content: View>:View{
    var contentView:Content
    var shouldRotate:Bool
    var action = {}
    var bg:some View = Color.black.opacity(0.75)
    var fgColor:Color = Color.white
    var font:Font = .title
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.action()
            }
        }) {
            contentView
                .rotationEffect(.degrees(shouldRotate ? 45.0 : 0.0))
                .scaleEffect(shouldRotate ? 1.5 : 1.0)
        }
        .padding()
        .background(bg)
        .foregroundColor(fgColor)
        .font(font)
        .clipShape(Circle())
    }
}

struct SideMenuBtn<Content: View>:View{
    
    var contentView:Content
    var action = {}
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.action()
            }
        }) {
            withAnimation {
                contentView
            }
        }
        .padding()
        .background(RoundedCorners(color: Color.black.opacity(0.75), half_tr: true, half_br: true))
        .foregroundColor(.white)
        .font(.title)
    }
}

struct NavBackBtn<Content: View>:View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var contentView:Content
    var action = {}
    
    var body: some View {
        
        Button(action: {
            action()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack{
                contentView
            }
            .frame(width: 50, height: 50, alignment: .center)
        }
        .foregroundColor(.white)
        .font(.title)
        Spacer()
        
    }
}
