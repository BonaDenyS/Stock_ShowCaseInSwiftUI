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

    let title = "Compare Stock"
    
    func higest() -> [Stock] {
        print("Stocks A = \(self.stocksA.count)")
        print("Stocks B = \(self.stocksB.count)")
        print("Stocks C = \(self.stocksC.count)")
        
        if(stocksA.count > stocksB.count && stocksA.count > stocksC.count){
            print("Higest Stock = \(self.stocksA.count)")
            return stocksA
        }else if (stocksB.count > stocksC.count) {
            print("Higest Stock = \(self.stocksB.count)")
            return stocksB
        }else{
            print("Higest Stock = \(self.stocksC.count)")
            return stocksC
        }
    }
    

    func stocks() -> [TagStock: [Stock]] {
        return [
            TagStock.A: self.stocksA,
            TagStock.B: self.stocksB,
            TagStock.C: self.stocksC
        ]
    }
    
    func fetch(tagStock: TagStock, symbol: String) {
        let queries = [
            Query.function:Function.intraday.rawValue,
            Query.interval: Interval.ts5.rawValue,
            Query.symbol: symbol
        ]
        
        HTTPManager().network(queries: queries) { stocks in
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
}
