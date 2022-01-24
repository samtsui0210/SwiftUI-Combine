//
//  CardView.swift
//  CustomCollectionView
//
//  Created by TsuiWingLok on 10/11/2020.
//

import UIKit

class CardView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(CornerRadius cornerRadius:CGFloat = 10.0){
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.8
    }

    
}
