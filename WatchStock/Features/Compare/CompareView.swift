//
//  CompareView.swift
//  WatchStock
//
//  Created by Bona Deny S on 10/12/20.
//  Copyright © 2020 Bona Deny S. All rights reserved.
//

import SwiftUI

struct CompareView: View {
    @ObservedObject var compareVM: CompareViewModel
    
    let stockA = Color.init(red: 79/255, green: 193/255, blue: 233/255)
    let stockB = Color.init(red: 236/255, green: 135/255, blue: 192/255)
    let stockC = Color.init(red: 172/255, green: 146/255, blue: 236/255)

    var body: some View {
        NavigationView {
            LoadingView(isShowing: .constant(self.compareVM.loading)) {
                GeometryReader { metrics in
                    VStack {
                        HStack {
                            HeaderView(compareVM: self.compareVM, stockA: self.stockA, stockB: self.stockB, stockC: self.stockC)
                        }.frame(height: metrics.size.height * 0.15)
                        
                        List {
                            ForEach(0..<self.compareVM.higest().count, id: \.self) { iterator in
                                VStack {
                                    BodyView(compareVM: self.compareVM, stockA: self.stockA, stockB: self.stockB, stockC: self.stockC, i: iterator)
                                }.frame(height: 100,alignment: .leading)
                            }
                        }.frame(height: metrics.size.height * 0.9, alignment: .leading)
                    }.navigationBarTitle(self.compareVM.title)
                }
            }
        }
    }
}

struct BodyView: View {
    @ObservedObject var compareVM: CompareViewModel
    
    var stockA: Color
    var stockB: Color
    var stockC: Color
    var i: Int
    
    var body: some View {
        GeometryReader { metrics in
            VStack {
                HStack {
                    VStack {
                        Text("Open :").frame(width: 100, alignment: .trailing)
                        Text("High :").frame(width: 100, alignment: .trailing)
                        Text("Low :").frame(width: 100, alignment: .trailing)
                        Text("Close :").frame(width: 100, alignment: .trailing)
                    }.frame(width: metrics.size.width * 0.20,alignment: .trailing)
                    if self.compareVM.stocksA.count > 0 && self.i < self.compareVM.stocksA.count {
                        VStack {
                            Text(self.compareVM.stocksA[self.i].open).frame(width: 100, alignment: .trailing)
                            Text(self.compareVM.stocksA[self.i].high).frame(width: 100, alignment: .trailing)
                            Text(self.compareVM.stocksA[self.i].low).frame(width: 100, alignment: .trailing)
                            Text(self.compareVM.stocksA[self.i].close).frame(width: 100, alignment: .trailing)
                        }.frame(width: metrics.size.width * 0.24,alignment: .trailing).foregroundColor(.white).padding(5).background(self.stockA).cornerRadius(5)
                    }else{
                        VStack {
                            Text("-").frame(width: 100, alignment: .center)
                            Text("-").frame(width: 100, alignment: .center)
                            Text("-").frame(width: 100, alignment: .center)
                            Text("-").frame(width: 100, alignment: .center)
                        }.frame(width: metrics.size.width * 0.24,alignment: .trailing).foregroundColor(.white).padding(5).background(self.stockA).cornerRadius(5)
                    }
                    if self.compareVM.stocksB.count > 0 && self.i < self.compareVM.stocksB.count {
                        VStack {
                            Text(self.compareVM.stocksB[self.i].open).frame(width: 100, alignment: .trailing)
                            Text(self.compareVM.stocksB[self.i].high).frame(width: 100, alignment: .trailing)
                            Text(self.compareVM.stocksB[self.i].low).frame(width: 100, alignment: .trailing)
                            Text(self.compareVM.stocksB[self.i].close).frame(width: 100, alignment: .trailing)
                        }.frame(width: metrics.size.width * 0.24,alignment: .trailing).foregroundColor(.white).padding(5).background(self.stockB).cornerRadius(5)
                    }else{
                        VStack {
                            Text("-").frame(width: 100, alignment: .center)
                            Text("-").frame(width: 100, alignment: .center)
                            Text("-").frame(width: 100, alignment: .center)
                            Text("-").frame(width: 100, alignment: .center)
                        }.frame(width: metrics.size.width * 0.24,alignment: .trailing).foregroundColor(.white).padding(5).background(self.stockB).cornerRadius(5)
                    }
                    if self.compareVM.stocksC.count > 0 && self.i < self.compareVM.stocksC.count {
                        VStack {
                            Text(self.compareVM.stocksC[self.i].open).frame(width: 100, alignment: .trailing)
                            Text(self.compareVM.stocksC[self.i].high).frame(width: 100, alignment: .trailing)
                            Text(self.compareVM.stocksC[self.i].low).frame(width: 100, alignment: .trailing)
                            Text(self.compareVM.stocksC[self.i].close).frame(width: 100, alignment: .trailing)
                        }.frame(width: metrics.size.width * 0.24,alignment: .trailing).foregroundColor(.white).padding(5).background(self.stockC).cornerRadius(5)
                    }else{
                        VStack {
                            Text("-").frame(width: 100, alignment: .center)
                            Text("-").frame(width: 100, alignment: .center)
                            Text("-").frame(width: 100, alignment: .center)
                            Text("-").frame(width: 100, alignment: .center)
                        }.frame(width: metrics.size.width * 0.24,alignment: .trailing).foregroundColor(.white).padding(5).background(self.stockC).cornerRadius(5)
                    }
                }
                HStack {
                    Text(self.compareVM.higest()[self.i].date).frame(alignment: .center)
                }
            }
        }
    }
}

struct HeaderView: View {
    @ObservedObject var compareVM: CompareViewModel
    
    var stockA: Color
    var stockB: Color
    var stockC: Color

    var body: some View {
        GeometryReader { metrics in
            HStack{
                Spacer().frame(width: metrics.size.width * 0.2, alignment: .leading)
                Button(action: {
                    self.compareVM.fetch(tagStock: TagStock.A, symbol: "AAPL")
                    self.compareVM.buttonA = "AAPL"
                }) {
                    Text(self.compareVM.buttonA).bold().foregroundColor(.white)
                }.frame(width: metrics.size.width * 0.24, height: metrics.size.width * 0.2, alignment: .center)
                    .background(self.stockA).cornerRadius(10)
                Button(action: {
                    self.compareVM.fetch(tagStock: TagStock.B, symbol: "UNVR")
                    self.compareVM.buttonB = "UNVR"
                }) {
                    Text(self.compareVM.buttonB).bold().foregroundColor(.white)
                }.frame(width: metrics.size.width * 0.24, height: metrics.size.width * 0.2, alignment: .center)
                    .background(self.stockB).cornerRadius(10)
                Button(action: {
                    self.compareVM.fetch(tagStock: TagStock.C, symbol: "IBM")
                    self.compareVM.buttonC = "IBM"
                }) {
                    Text(self.compareVM.buttonC).bold().foregroundColor(.white)
                }.frame(width: metrics.size.width * 0.24, height: metrics.size.width * 0.2, alignment: .center)
                    .background(self.stockC).cornerRadius(10)
            }.frame(width: metrics.size.width, alignment: .center).padding(.top)
        }
    }
}

struct CompareView_Previews: PreviewProvider {
    static var previews: some View {
        CompareView(compareVM: CompareViewModel())
    }
}
