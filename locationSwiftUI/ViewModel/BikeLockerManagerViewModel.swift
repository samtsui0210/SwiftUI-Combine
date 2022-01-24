//
//  BikeLockerManagerViewModel.swift
//  LinkaSupport
//
//  Created by TsuiWingLok on 7/7/2020.
//

import Foundation

class BikeLockerManagerViewModel: ObservableObject{
    
    @Published var state:State = .idle
    @Published var qrScanAction:Bool = false
    
    enum State{
        case idle
        case loading
        case complete
        case disconnected
        case connected
        case error
    }
    
    enum Event{
        case onAppear
        case onLogin
        case onInputError
        case onLoginError
    }
    
    func onConnectLock(){
        self.state = .connected
    }
    
}
