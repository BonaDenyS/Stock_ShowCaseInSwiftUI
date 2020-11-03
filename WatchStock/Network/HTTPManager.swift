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
    
    func network(queries: [Query:String], completion: @escaping (Result<[Stock], Error>) -> Void) {
        URLSession.shared.dataTask(with: query(queries: queries)) { (data, response, error) in
            DispatchQueue.main.async {
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                    if let raw = json["Time Series (\(queries[Query.interval]!))"] as? NSDictionary {
                        let stocks: [Stock] = raw.map { (key, values) in
                            let values = (values as! NSDictionary).allValues
                            return Stock(date: key as! String,
                                open: values[0] as! String,
                                high: values[1] as! String,
                                low:  values[2] as! String,
                                close: values[3] as! String,
                                volume: values[4] as! String
                            )
                        }
                        completion(.success(stocks))
                    }else {
                        completion(.success([Stock]()))
                    }
                } catch let jsonError {
                    completion(.failure(jsonError))
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
