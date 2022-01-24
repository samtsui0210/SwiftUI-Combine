//
//  MaskView.swift
//  LinkaSupport
//
//  Created by TsuiWingLok on 8/7/2020.
//

import Foundation
import SwiftUI
import UIKit

struct MaskView: UIViewRepresentable {
    
    typealias UIViewType = MaskPreview
    
    func makeUIView(context: Context) -> MaskPreview {
        let maskPreview = MaskPreview()
        return maskPreview
    }
    
    func updateUIView(_ uiView: MaskPreview, context: Context) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
}
