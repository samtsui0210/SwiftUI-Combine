//
//  MaskPreview.swift
//  LinkaSupport
//
//  Created by TsuiWingLok on 8/7/2020.
//

import UIKit

class MaskPreview: UIView {
    override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
}
