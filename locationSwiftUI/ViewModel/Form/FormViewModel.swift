//
//  FormViewModel.swift
//  locationSwiftUI
//
//  Created by SamTsui on 6/5/2022.
//

import Foundation
import Combine

class FormViewModel: ObservableObject {
    
    @Published var typeText: String = ""
    @Published var showTypeError: Bool = false
    
    @Published var nameText: String = ""
    
    @Published var descText: String = ""
    
    @Published var latText: String = ""
    @Published var lngText: String = ""
    
    private var subscription: Set<AnyCancellable> = []
    
    var time:Date = Date()
    
    init(){
        
        $typeText
//            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
                        .removeDuplicates()
                        .dropFirst()
                        .map({ (string) -> String? in
                            return string
                        })
                        .compactMap{ $0 }
                        .sink { result in
                            switch result{
                            case .finished:
                                break
                            case .failure(let error):
                                print(error)
                            }
                        } receiveValue: { [self] (text) in
                            showTypeError = text.isEmpty
                        }.store(in: &subscription)
        
        let latPublisher = $latText
                                .removeDuplicates()
                                .dropFirst()
                                .map({ (string) -> String? in
                                    return string
                                })
                                .compactMap{ $0 }
        
        // Validate both lat, lng
        let lngPublisher = $lngText
                                .removeDuplicates()
                                .dropFirst()
                                .map({ (string) -> String? in
                                    return string
                                })
                                .compactMap{ $0 }
        
        Publishers.CombineLatest(latPublisher, lngPublisher)
            .sink { (_) in
            } receiveValue: { [self] (lat, lng) in
                print("lat: \(lat) lng: \(lng)")
            }.store(in: &subscription)
        
    }
    
}

