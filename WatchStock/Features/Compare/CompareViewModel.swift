//
//  CompareViewModel.swift
//  WatchStock
//
//  Created by Bona Deny S on 10/12/20.
//  Copyright © 2020 Bona Deny S. All rights reserved.
//

import Foundation

enum TagStock {
    case A
    case B
    case C
}

class CompareViewModel: ObservableObject {
    @Published var stocksA = [Stock]()
    @Published var stocksB = [Stock]()
    @Published var stocksC = [Stock]()
    
    @Published var buttonA = "+"
    @Published var buttonB = "+"
    @Published var buttonC = "+"
    
    @Published var loading = false

    let title = "Compare Stock"
    
    func higest() -> [Stock] {
        if(stocksA.count > stocksB.count && stocksA.count > stocksC.count){
            return stocksA
        }else if (stocksB.count > stocksC.count) {
            return stocksB
        }else{
            return stocksC
        }
    }
    
    func fetch(tagStock: TagStock, symbol: String) {
        let queries = [
            Query.function:Function.intraday.rawValue,
            Query.interval: Interval.ts5.rawValue,
            Query.symbol: symbol
        ]
        self.loading = true
        
        HTTPManager().network(queries: queries) { (result) in
            switch result {
                case .success(let stocks): self.whichStocks(tagStock, stocks)
                case .failure(let error) : print("Failed to fetch stocks :", error)
            }
            self.loading = false
        }
    }
    
    fileprivate func whichStocks(_ tagStock: TagStock, _ stocks: [Stock]) {
        switch(tagStock){
        case TagStock.A : self.stocksA = stocks
            break
        case TagStock.B : self.stocksB = stocks
            break
        default : self.stocksC = stocks
            break
        }
    }
}
