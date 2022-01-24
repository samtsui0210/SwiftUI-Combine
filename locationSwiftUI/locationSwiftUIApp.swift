//
//  locationSwiftUIApp.swift
//  locationSwiftUI
//
//  Created by TsuiWingLok on 16/7/2020.
//

import SwiftUI

@main
struct locationSwiftUIApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background {
               //perform cleanup
            }
        }
        
        #if os(macOS)
            Settings{
                ContentView()
            }
        #endif
        
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            return true
        }
    }
