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
        case Form
    }
    
    typealias Page = MainViewPage
    
    @Published var currentPage =  Page.Home
    @Published var isNavigator =  false
    
    let homeView = HomeView()
    let mapControlView = MapControlView()
    let formView = FormView()
    
    override init() {
        super.init()
    }
    
    func setPage(_ page: Page){
        currentPage = page
        
        if currentPage == .Form{
            showNav(true)
        }else{
            showNav(false)
        }

    }
    
    func showNav(_ show: Bool){
        isNavigator = show
    }
    
}
