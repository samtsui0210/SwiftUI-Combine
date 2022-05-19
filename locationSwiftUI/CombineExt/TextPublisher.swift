//
//  TextPublisher.swift
//  locationSwiftUI
//
//  Created by SamTsui on 13/5/2022.
//

//import Combine
//import UIKit
//
//extension UITextField {
//    var textPublisher: AnyPublisher<String?, Never> {
//        NotificationCenter.default
//            .publisher(for: UITextField.textDidChangeNotification, object: self)
//            .compactMap { $0.object as? UITextField }
//            .filter { $0 == self }
//            .map { $0.text}
//            .eraseToAnyPublisher()
//    }
//}
