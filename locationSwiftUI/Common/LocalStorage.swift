//
//  Helper.swift
//  locationSwiftUI
//
//  Created by TsuiWingLok on 12/11/2020.
//

import Foundation
import SwiftUI
import WidgetKit

let appGroupName = "group.com.locationSwiftUI"

let userDefaultsStringKey = "Test"
let userDefaultsPhotosKey = "WidgetPhoto"
let userDefaultsMapViewKey = "MapView"
 
struct LocalStorage {
    
    //    static func getImageIdsFromUserDefault() -> [String] {
    //
    //        if let userDefaults = UserDefaults(suiteName: appGroupName) {
    //            if let data = userDefaults.data(forKey: userDefaultsPhotosKey) {
    //                return try! JSONDecoder().decode([String].self, from: data)
    //            }
    //        }
    //
    //        return [String]()
    //    }
    
    static func getStringFromUserDefaults(key: String = userDefaultsStringKey) -> String {
        if let userDefaults = UserDefaults(suiteName: appGroupName) {
            if let string = userDefaults.object(forKey: key) as? String{
                return string
            }
        }
        return "fail"
    }
    
    static func saveStringUserDefaults() {
        if let userDefaults = UserDefaults(suiteName: appGroupName) {
            userDefaults.set("test", forKey: userDefaultsStringKey)
        }
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    
    static func getImageFromUserDefaults(key: String = userDefaultsPhotosKey) -> UIImage {
        if let userDefaults = UserDefaults(suiteName: appGroupName) {
            if let imageData = userDefaults.object(forKey: key) as? Data,
               let image = UIImage(data: imageData) {
                return image
            }
        }
        
        return UIImage(systemName: "photo.fill.on.rectangle.fill")!
    }
    
    static func saveIntoUserDefaults(image: UIImage) {
        if let userDefaults = UserDefaults(suiteName: appGroupName) {
            if let jpegRepresentation = image.jpegData(compressionQuality: 0.5) {
                userDefaults.set(jpegRepresentation, forKey: userDefaultsPhotosKey)
            }
        }
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    static func saveMapSnapshot(image: UIImage) {
        if let userDefaults = UserDefaults(suiteName: appGroupName) {
            if let jpegRepresentation = image.jpegData(compressionQuality: 0.5) {
                userDefaults.set(jpegRepresentation, forKey: userDefaultsMapViewKey)
            }
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    static func getMapSnapshot(key: String = userDefaultsMapViewKey) -> UIImage {
        if let userDefaults = UserDefaults(suiteName: appGroupName) {
            if let imageData = userDefaults.object(forKey: key) as? Data,
               let image = UIImage(data: imageData) {
                return image
            }
        }
        
        return UIImage(systemName: "photo.fill.on.rectangle.fill")!
    }
    
}

struct LocalStorage_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
