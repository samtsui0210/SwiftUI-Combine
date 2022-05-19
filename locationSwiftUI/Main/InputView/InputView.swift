//
//  InputView.swift
//  locationSwiftUI
//
//  Created by SamTsui on 13/5/2022.
//

import UIKit
import Combine

class InputView: UIView{
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tfInput: UITextField!
    @IBOutlet weak var lbError: UILabel!
    
    func setup(title:String, error:String){
        lbTitle.text = title
        lbError.text = error
        
        lbError.isHidden = true
    }
    
}
