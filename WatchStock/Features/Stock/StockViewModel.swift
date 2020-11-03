//
//  StockViewModel.swift
//  WatchStock
//
//  Created by Bona Deny S on 10/12/20.
//  Copyright © 2020 Bona Deny S. All rights reserved.
//

import Foundation

class StockViewModel: ObservableObject {
        
    @Published var stocks = [Stock]()
    @Published var loading = false
    @Published var symbol = "AAPL"
        
    let title = "Stock Today"
    
    private var sortByDate = false
    private var sortByOpen = false
    private var sortByHigh = false
    private var sortByLow = false

    func byDate() {
        self.stocks.sort { (aStock,bStock) -> Bool in
            aStock.date.compare(bStock.date) == (sortByDate == false ? .orderedDescending : .orderedAscending)
        }
        self.sortByDate.toggle()
    }
    
    func byOpen() {
        self.stocks.sort { (aStock,bStock) -> Bool in
            aStock.open.compare(bStock.open) == (sortByOpen == false ? .orderedDescending : .orderedAscending)
        }
        self.sortByOpen.toggle()
    }
    
    func byHigh() {
        self.stocks.sort { (aStock,bStock) -> Bool in
            aStock.high.compare(bStock.high) == (sortByHigh == false ? .orderedDescending : .orderedAscending)
        }
        self.sortByHigh.toggle()
    }
    
    func byLow() {
        self.stocks.sort { (aStock,bStock) -> Bool in
            aStock.low.compare(bStock.low) == (sortByLow == false ? .orderedDescending : .orderedAscending)
        }
        self.sortByLow.toggle()
    }
    
    func refresh() {
        self.symbol = "AAPL"
    }
    
    func fetch(symbol: String) {
        let queries = [
            Query.function:Function.intraday.rawValue,
            Query.interval: Interval.ts5.rawValue,
            Query.symbol: symbol
        ]
        self.loading = true
        HTTPManager().network(queries: queries) { (result) in
            switch result {
                case .success(let stocks): self.stocks = stocks
                case .failure(let error) : print("Failed to fetch stocks :", error)
            }
            self.symbol = self.stocks.count > 0 ? symbol : "-"
            self.loading = false
        }
    }
}
