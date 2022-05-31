//
//  ScannerViewModel.swift
//  LinkaSupport
//
//  Created by TsuiWingLok on 7/7/2020.
//

import Foundation
import AVFoundation

class ScannerViewModel: ObservableObject {
    
    static let shared = ScannerViewModel()
    
    let scanInterval: Double = 1.0
    
    @Published var torchIsOn: Bool = false
    
    @Published var scannedQRcode:AVMetadataMachineReadableCodeObject?
    
    @Published var didScanQRcode:Bool = false
    
    var cameraView: CameraPreview?
    
    func onFoundQrCode(_ result: AVMetadataMachineReadableCodeObject) {
        self.scannedQRcode = result
        self.didScanQRcode = true
    }
    
    func setPreviewLayer(_ uiview: CameraPreview){
        self.cameraView = uiview
    }
    
}
