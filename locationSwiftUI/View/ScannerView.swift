//
//  ScannerView.swift
//  LinkaSupport
//
//  Created by TsuiWingLok on 7/7/2020.
//

import SwiftUI

struct ScannerView: View {
    
    @Binding var macAddress:String
    
    @EnvironmentObject var viewModel:ScannerViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private let qrcodeScannerView = QrCodeScannerView()
    
    var body: some View {
        
        CustomNavView(contentView:
                        qrcodeScannerView
                        .found(r: { qrCode in
                            self.viewModel.onFoundQrCode(qrCode)
                            self.macAddress = self.viewModel.lastQrCode
                            self.viewModel.lastQrCode = ""
                            self.presentationMode.wrappedValue.dismiss()
                        })
                        .torchLight(isOn: self.viewModel.torchIsOn)
                        .interval(delay: self.viewModel.scanInterval),
                      isFullScreen: true, backAction: {
                        self.macAddress = self.viewModel.lastQrCode
                        self.viewModel.lastQrCode = ""
                      })
    }
    
    struct InnerSquare: Shape {
        
        var ratio:CGFloat = 0.8
        
        func path(in rect: CGRect) -> Path {
            Path { (path) in
                
                let minX = ( rect.maxX * (1 - ratio) ) / 2
                let maxX = minX + (rect.maxX * 0.8)
                let minY = (rect.maxY - (rect.maxX * 0.8) ) / 2
                let maxY = rect.maxY - minY
                
                path.addLines([
                    CGPoint(x: minX, y: minY),
                    CGPoint(x: maxX, y: minY),
                    CGPoint(x: maxX, y: maxY),
                    CGPoint(x: minX, y: maxY),
                    CGPoint(x: minX, y: minY)
                ])
            }
        }
    }
    
}

struct ScannerView_Previews: PreviewProvider {
    
    static var previews: some View {
        ScannerView(macAddress: .constant("Test")).environmentObject(ScannerViewModel())
    }
}
