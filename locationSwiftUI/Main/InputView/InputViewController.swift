//
//  InputViewController.swift
//  locationSwiftUI
//
//  Created by SamTsui on 13/5/2022.
//

import UIKit
import Combine
import CombineCocoa

class InputViewController: UIViewController {

    @IBOutlet weak var titleInputView: InputView!
    
    @IBOutlet weak var clearButton: UIButton!
    
    
    private var subscription: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleInputView.setup(title: "Title", error: "Empty title")
        
       
        let titleTextPublisher = titleInputView.tfInput.textPublisher
            .dropFirst(2)
            .map({ (string) -> String? in
                return string
            })
            .compactMap{ $0 }
        
        titleTextPublisher.sink { _ in
        } receiveValue: { text in
            self.titleInputView.lbError.isHidden = (text != "")
        }.store(in: &subscription)

        
        let clearButtonPublisher = clearButton.tapPublisher
//            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
        
        clearButtonPublisher.sink { _ in
                self.titleInputView.tfInput.text = ""
                self.titleInputView.lbError.isHidden = true
            }
            .store(in: &subscription)
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
