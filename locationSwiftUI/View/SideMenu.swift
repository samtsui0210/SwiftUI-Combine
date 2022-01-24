//
//  SideMenu.swift
//  locationSwiftUI
//
//  Created by TsuiWingLok on 16/11/2020.
//

import SwiftUI

struct SideMenu: View {
    
    var topSafeArea:CGFloat
    
    @State private var showImagePicker:Bool = false
    @State private var showQRscan:Bool = false
    
    @State private var image = UIImage()
    
    @State var macAddress:String = ""
    @State var qrScanAction:Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Button(action: {
                self.showImagePicker.toggle()
            }) {
                HStack {
                    Image(systemName: "photo")
                        .foregroundColor(.white)
                        .imageScale(.large)
                    Text("Widget Image")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding(.top, topSafeArea + 30)
            }
            .foregroundColor(.white)
            .font(.title)
            .sheet(isPresented: $showImagePicker , content: {
                ImagePicker(selectedImage: self.$image)
            })
            .onChange(of: image) { _ in
                LocalStorage.saveIntoUserDefaults(image: image)
            }
            
            NavigationLink(
                destination: CustomNavView(contentView: ViewControllerPreview())
            ){
                HStack {
                    Image(systemName: "folder")
                        .foregroundColor(.white)
                        .imageScale(.large)
                    Text("Collection View")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .font(.title)
            }
            
            NavigationLink( destination: ScannerView(macAddress: $macAddress).environmentObject(ScannerViewModel()), isActive: self.$qrScanAction){
                Button(action:{
                    UIApplication.shared.endEditing()
                    self.qrScanAction = true
                }){
                    HStack {
                        Image(systemName: "qrcode.viewfinder")
                            .foregroundColor(.white)
                            .imageScale(.large)
                        Text("QR Scan")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .font(.title)
                }
            }
            
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black.opacity(0.75))
        .edgesIgnoringSafeArea(.all)
    }
}

struct SideMenu_Previews: PreviewProvider {
    
    static var previews: some View {
        SideMenu(topSafeArea: 50)
    }
}
