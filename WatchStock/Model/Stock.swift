//
//  Stock.swift
//  WatchStock
//
//  Created by Bona Deny S on 10/12/20.
//  Copyright © 2020 Bona Deny S. All rights reserved.
//

import Foundation

struct Stock: Codable, Identifiable {
    let id = UUID()
    let date, open, high, low, close, volume: String
    
}
