//
//  HTTPManager.swift
//  WatchStock
//
//  Created by Bona Deny S on 10/11/20.
//  Copyright © 2020 Bona Deny S. All rights reserved.
//

import Foundation

enum Query: String {
    case function = "function"
    case symbol = "symbol"
    case interval = "interval"
    case outputsize = "outputsize"
    case apikey = "apikey"
}

enum Interval: String {
    case ts1 = "1min"
    case ts5 = "5min"
    case ts15 = "15min"
    case ts30 = "30min"
    case ts60 = "60min"
    case daily = "Daily"
}

enum Function: String {
    case intraday = "TIME_SERIES_INTRADAY"
    case daily = "TIME_SERIES_DAILY"
}

class HTTPManager {
    private var base_key = "USE_YOUR_OWN_API_KEY"
    private var outputsize = "compact"
    private var interval = "5min"
    
    private let base_url = "https://www.alphavantage.co/"
    private var stocks: [Stock] = []
    
    init() {
        if let receivedData = KeychainSwift().get(Query.apikey.rawValue) {
             self.base_key = receivedData
        }        
        if let interval = UserDefaults.standard.string(forKey: Query.interval.rawValue) {
            self.interval = interval
        }
        if let size = UserDefaults.standard.string(forKey: Query.outputsize.rawValue) {
            self.outputsize = size
        }
    }
    
    func network(queries: [Query:String], completion: @escaping ([Stock]) -> Void) {
        URLSession.shared.dataTask(with: query(queries: queries)) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else { return }
                let rawData = try! JSONSerialization.jsonObject(with: data) as! NSDictionary
                if let stocks = rawData["Time Series (\(queries[Query.interval]!))"] as? NSDictionary { //Make it properly Query.interval
                    for i in 0..<stocks.count{
                        self.stocks.append(
                            Stock(date: stocks.allKeys[i] as! String,
                                  open: (stocks.allValues[i] as! NSDictionary).allValues[0] as! String,
                                  high: (stocks.allValues[i] as! NSDictionary).allValues[1] as! String,
                                  low: (stocks.allValues[i] as! NSDictionary).allValues[2] as! String,
                                  close: (stocks.allValues[i] as! NSDictionary).allValues[3] as! String,
                                  volume: (stocks.allValues[i] as! NSDictionary).allValues[4] as! String
                            )
                        )
                    }
                    completion(self.stocks)
                }else{
                    print("error: \(rawData)")
                    completion(self.stocks)
                }
            }
        }.resume()
    }
    
    private func query(queries: [Query:String]) -> URL{
        var compounents = URLComponents(string: base_url+"query")
        compounents?.queryItems = [
            URLQueryItem(name: Query.function.rawValue, value: queries[Query.function]),
            URLQueryItem(name: Query.symbol.rawValue, value: queries[Query.symbol]),
            URLQueryItem(name: Query.outputsize.rawValue, value: outputsize),
            URLQueryItem(name: Query.apikey.rawValue, value: base_key)
        ]
        if(queries[Query.function] == Function.intraday.rawValue){
            compounents?.queryItems?.append(URLQueryItem(name: Query.interval.rawValue, value: queries[Query.interval]))
        }
        return (compounents?.url)!
    }
}
