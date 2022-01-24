//
//  ViewControllerPreview.swift
//  locationSwiftUI
//
//  Created by TsuiWingLok on 17/11/2020.
//

import SwiftUI
import UIKit

struct ViewControllerPreview: UIViewControllerRepresentable{
    
    typealias UIViewControllerType = UIViewController
    
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ViewController")
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
}

struct ViewControllerPreview_previews: PreviewProvider{
    static var previews: some View{
        ViewControllerPreview()
    }
}
