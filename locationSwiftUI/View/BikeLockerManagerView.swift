//
//  BikeLockerManagerView.swift
//  LinkaSupport
//
//  Created by TsuiWingLok on 7/7/2020.
//

import SwiftUI

struct BikeLockerManagerView: View{
    
    @EnvironmentObject var bikeLockerManagerViewModel:BikeLockerManagerViewModel
    
    @State private var name = ""
    @State private var password = ""
    
    @State private var isValidate:Bool? = false
    
    private let navBg = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
    
    
    
    var dissmissKeyboardTap: some Gesture{
        TapGesture(count: 1)
        .onEnded { _ in
            UIApplication.shared.endEditing()
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                VStack(spacing: 20){
                    Status()
                        .frame(maxWidth: .infinity)
                        .padding(20)
                    ControlMenu(menuWidth: geometry.size.width/2)
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
            }.gesture(self.dissmissKeyboardTap)
        }
    }
    
    struct Status: View{
        
        @EnvironmentObject var bikeLockerManagerViewModel:BikeLockerManagerViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10){
                if bikeLockerManagerViewModel.state == .connected{
                    Text("Lock Status : Connected")
                    .frame(maxWidth: .infinity, alignment: .leading)
                }else{
                    Text("Lock Status : ")
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Text("Battery : ")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            }
        }
        
    }
    
    struct ControlMenu: View {
        
        @State var menuWidth:CGFloat
        @State var macAddress:String = ""
        
        var body: some View {
            VStack(spacing: 20){
                qrScanButton(macAddress: $macAddress)
                tfMacAddress(macAddress: $macAddress)
                ControlButton(buttonWidth: menuWidth, buttonText: "Connect")
                ControlButton(buttonWidth: menuWidth, buttonText: "Unlock")
                ControlButton(buttonWidth: menuWidth, buttonText: "Lock")
                ControlButton(buttonWidth: menuWidth, buttonText: "Disconnect", buttonTextColor: .red)
            }
            .frame(width: menuWidth)
        }
    }
    
    struct tfMacAddress: View{
        
        @Binding var macAddress:String
        
        var body: some View {
            TextField("Enter Mac Address", text: $macAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .font(Font.system(size: 14))
        }
        
    }
    
    struct qrScanButton: View{
        
        @Binding var macAddress:String
        @State var qrScanAction:Bool = false
        
        var body: some View {
            NavigationLink( destination: ScannerView(macAddress: $macAddress).environmentObject(ScannerViewModel.shared), isActive: self.$qrScanAction){
                Button(action:{
                    UIApplication.shared.endEditing()
                    self.qrScanAction = true
                }){
                    Text("Scan QR code")
                }
            }
        }
        
    }
    
    struct ControlButton: View {
        
        @State var buttonWidth:CGFloat
        @State var buttonText:String
        @State var buttonTextColor:Color = .black
        
        private let buttonBg = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
        
        var body: some View {
            Button(action: {
                
            }){
                Text(buttonText)
                    .frame(width: buttonWidth, height: 50)
            }
            .foregroundColor(buttonTextColor)
            .background(Color(self.buttonBg))
        }
        
    }
    
}

struct BikeLockerManagerView_Previews: PreviewProvider {
    static var previews: some View {
        BikeLockerManagerView()
    }
}
