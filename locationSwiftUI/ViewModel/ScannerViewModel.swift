//
//  ScannerViewModel.swift
//  LinkaSupport
//
//  Created by TsuiWingLok on 7/7/2020.
//

import Foundation

class ScannerViewModel: ObservableObject {
    
    /// Defines how often we are going to try looking for a new QR-code in the camera feed.
    let scanInterval: Double = 1.0
    var didScanQRcode: Bool = false
    
    @Published var torchIsOn: Bool = false
    @Published var lastQrCode: String = ""
    
    func onFoundQrCode(_ code: String) {
        self.lastQrCode = code
    }
    
}
