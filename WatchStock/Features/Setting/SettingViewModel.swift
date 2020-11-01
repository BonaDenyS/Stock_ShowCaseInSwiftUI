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
    let sizeList = ["compact","full"]
    let title = "Setting"
    
    func setPreference(_ apikey:String, _ interval:String, _ size:String) {
        KeychainSwift().set(apikey, forKey: Query.apikey.rawValue)
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
        UserDefaults.standard.set(interval, forKey: Query.interval.rawValue)
        UserDefaults.standard.set(size.lowercased(), forKey: Query.outputsize.rawValue)
    }
    
    func refresh(_ apikey:inout String, _ interval:inout Int, _ size:inout Int) {
        if let r_apikey = KeychainSwift().get(Query.apikey.rawValue) {
             apikey = r_apikey
        }
        if let r_interval = UserDefaults.standard.string(forKey: Query.interval.rawValue) {
            interval = intervalList.firstIndex(of: r_interval) ?? 0
        }
        if let r_size = UserDefaults.standard.string(forKey: Query.outputsize.rawValue) {
            size = sizeList.firstIndex(of: r_size) ?? 0
        }
    }
}
