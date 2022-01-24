//
//  ContentView.swift
//  locationSwiftUI
//
//  Created by TsuiWingLok on 16/7/2020.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
//        ViewControllerPreview()
        MapControlView()
                    .environmentObject(LocationManager())
                    .environmentObject(MapControlViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
