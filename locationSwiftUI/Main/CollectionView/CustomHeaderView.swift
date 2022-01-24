//
//  CustomHeaderView.swift
//  CustomCollectionView
//
//  Created by TsuiWingLok on 28/10/2020.
//

import UIKit


class CustomHeaderView: UICollectionReusableView{
    let label = UILabel()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        
        label.textColor = .white
        backgroundColor = .lightGray
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    
}
