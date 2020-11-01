//
//  SettingViewModel.swift
//  WatchStock
//
//  Created by Bona Deny S on 10/30/20.
//  Copyright © 2020 Bona Deny S. All rights reserved.
//

import Foundation

class SettingViewModel: ObservableObject {
    
    @Published var loading = false
    
    let intervalList = ["1min", "5min", "15min", "30min", "60min"]
    let sizeList = ["Compact","Full"]
    let title = "Setting"
    
    func setPreference(_ apikey:String, _ interval:String, _ size:String) {
        KeychainSwift().set(apikey, forKey: Query.apikey.rawValue)
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
        UserDefaults.standard.set(interval, forKey: Query.interval.rawValue)
        UserDefaults.standard.set(size.lowercased(), forKey: Query.outputsize.rawValue)
    }
}
