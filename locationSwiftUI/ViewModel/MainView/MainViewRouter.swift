//
//  MainViewRouter.swift
//  locationSwiftUI
//
//  Created by Sam Tsui on 26/1/2022.
//

import SwiftUI

class MainViewRouter: NSObject, ObservableObject {
    
    enum MainViewPage{
        case Home
        case Map
    }
    
    typealias Page = MainViewPage
    
    @Published var currentPage =  Page.Home
    
    let homeView = HomeView()
    let mapControlView = MapControlView()
    
    override init() {
        super.init()
    }
    
    func setPage(_ page: Page){
        currentPage = page
    }
    
}
