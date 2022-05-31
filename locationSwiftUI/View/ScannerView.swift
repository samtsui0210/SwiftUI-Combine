//
//  ScannerView.swift
//  LinkaSupport
//
//  Created by TsuiWingLok on 7/7/2020.
//

import SwiftUI
import AVFoundation

struct ScannerView: View {
    
    @Binding var macAddress:String
    
    @EnvironmentObject var viewModel:ScannerViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private let qrcodeScannerView = QrCodeScannerView()
    
    var body: some View {
        
        GeometryReader(content: { geometry in
            
            ZStack{
                qrcodeScannerView
                .found(r: { result in
                    self.viewModel.onFoundQrCode(result)
//                    self.viewModel.cameraView?.session.stopRunning()
                    
                })
                .torchLight(isOn: self.viewModel.torchIsOn)
                .interval(delay: self.viewModel.scanInterval)
                    
                    VStack {
                        HStack {
                            NavBackBtn(contentView: Image(systemName: "arrow.left")){
                                self.viewModel.cameraView?.session.stopRunning()
                            }
                        }
                        .padding(0)
                        Spacer()
                    }
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
                .padding(.top, 0)

                if viewModel.didScanQRcode &&
                    viewModel.scannedQRcode?.corners.count ?? 0 > 1{
                    Path(){ path in
                        let previewLayer = viewModel.cameraView?.previewLayer
                        let corners = mapScannedCorners(previewLayer, metadataObject: viewModel.scannedQRcode!)
                        path.addLines(corners)
                        path.closeSubpath()
                    }.stroke(.green, lineWidth: 5)
                }
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
    
    func mapScannedCorners(_ previewLayer:AVCaptureVideoPreviewLayer?, metadataObject:AVMetadataMachineReadableCodeObject) -> [CGPoint]{
        var points:[CGPoint] = []
        
        if let barCodeObject = previewLayer?
            .transformedMetadataObject(for: metadataObject) as? AVMetadataMachineReadableCodeObject{
            points = barCodeObject.corners
        }
        
        return points
    }
    
}

struct ScannerView_Previews: PreviewProvider {
    
    static var previews: some View {
        ScannerView(macAddress: .constant("Test")).environmentObject(ScannerViewModel())
    }
}
