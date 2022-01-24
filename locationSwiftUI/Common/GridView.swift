//
//  GridView.swift
//  LinkaSupport
//
//  Created by TsuiWingLok on 8/7/2020.


import SwiftUI

struct GridViewVertical:View{
    
    var columns: [GridItem] = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach((0...79), id: \.self) {
                    let codepoint = $0 + 0x1f600
                    let emoji = String(Character(UnicodeScalar(codepoint)!))
                    Text("\(emoji)")
                }
            }
        }
    }
}

struct GridViewHorizontal:View{
    
    var rows: [GridItem] = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, alignment: .top) {
                ForEach((0...79), id: \.self) {
                    let codepoint = $0 + 0x1f600
                    let emoji = String(Character(UnicodeScalar(codepoint)!))
                    Text("\(emoji)")
                }
            }
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridViewVertical()
    }
}
