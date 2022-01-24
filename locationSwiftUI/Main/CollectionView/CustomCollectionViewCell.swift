//
//  customCollectionCell.swift
//  CustomCollectionView
//
//  Created by TsuiWingLok on 27/10/2020.
//

import Foundation
import UIKit

class CustomCollectionViewCell: UICollectionViewCell{
    let label = UILabel()
    let view = CardView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func setup(){
        
        contentView.backgroundColor = .clear
        
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8.0).isActive = true
        view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8.0).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0).isActive = true
        view.backgroundColor = UIColor(red: 60/255, green: 120/255, blue: 240/255, alpha: 1.0)
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.textColor = .black
        
//        backgroundColor = UIColor(red: 60/255, green: 120/255, blue: 240/255, alpha: 1.0)
    }
    
}
