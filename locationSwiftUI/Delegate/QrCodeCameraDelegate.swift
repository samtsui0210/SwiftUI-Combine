//
//  QrCodeCameraDelegate.swift
//  LinkaSupport
//
//  Created by TsuiWingLok on 7/7/2020.
//

import Foundation
import AVFoundation

class QrCodeCameraDelegate: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    var scanInterval: Double = 1.0
    var lastTime = Date(timeIntervalSince1970: 0)
    
    var onResult: (AVMetadataMachineReadableCodeObject) -> Void = { _  in }
    var mockData: String?
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            foundBarcode(readableObject)
        }
    }
    
    @objc func onSimulateScanning(){
//        foundBarcode(mockData ?? "Simulated QR-code result.")
    }
    
    func foundBarcode(_ result: AVMetadataMachineReadableCodeObject) {
        let now = Date()
        if now.timeIntervalSince(lastTime) >= scanInterval {
            lastTime = now
            if result.type == .qr{
                self.onResult(result)
            }
        }
    }
}
