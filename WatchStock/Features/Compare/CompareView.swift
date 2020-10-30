//
//  CompareView.swift
//  WatchStock
//
//  Created by Bona Deny S on 10/12/20.
//  Copyright © 2020 Bona Deny S. All rights reserved.
//

import SwiftUI

struct CompareView: View {
    @ObservedObject var viewModel: CompareViewModel
    
    let stockA = Color.init(red: 79/255, green: 193/255, blue: 233/255)
    let stockB = Color.init(red: 236/255, green: 135/255, blue: 192/255)
    let stockC = Color.init(red: 172/255, green: 146/255, blue: 236/255)

    var body: some View {
        NavigationView {
            LoadingView(isShowing: .constant(self.viewModel.loading)) {
                GeometryReader { metrics in
                    VStack {
                        HStack {
                            HeaderView(viewModel: self.viewModel, stockA: self.stockA, stockB: self.stockB, stockC: self.stockC)
                        }.frame(height: metrics.size.height * 0.15)
                        
                        List {
                            ForEach(0..<self.viewModel.higest().count, id: \.self) { iterator in
                                VStack {
                                    BodyView(viewModel: self.viewModel, stockA: self.stockA, stockB: self.stockB, stockC: self.stockC, i: iterator)
                                }.frame(height: 100,alignment: .leading)
                            }
                        }.frame(height: metrics.size.height * 0.84, alignment: .leading)
                        Spacer().frame(height: metrics.size.height * 0.01)
                    }.navigationBarTitle(self.viewModel.title)
                }
            }
        }
    }
}

struct BodyView: View {
    @ObservedObject var viewModel: CompareViewModel
    
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
                    if self.viewModel.stocksA.count > 0 && self.i < self.viewModel.stocksA.count {
                        VStack {
                            Text(self.viewModel.stocksA[self.i].open).frame(width: 100, alignment: .trailing)
                            Text(self.viewModel.stocksA[self.i].high).frame(width: 100, alignment: .trailing)
                            Text(self.viewModel.stocksA[self.i].low).frame(width: 100, alignment: .trailing)
                            Text(self.viewModel.stocksA[self.i].close).frame(width: 100, alignment: .trailing)
                        }.frame(width: metrics.size.width * 0.24,alignment: .trailing).foregroundColor(.white).padding(5).background(self.stockA).cornerRadius(5)
                    }else{
                        VStack {
                            Text("-").frame(width: 100, alignment: .center)
                            Text("-").frame(width: 100, alignment: .center)
                            Text("-").frame(width: 100, alignment: .center)
                            Text("-").frame(width: 100, alignment: .center)
                        }.frame(width: metrics.size.width * 0.24,alignment: .trailing).foregroundColor(.white).padding(5).background(self.stockA).cornerRadius(5)
                    }
                    if self.viewModel.stocksB.count > 0 && self.i < self.viewModel.stocksB.count {
                        VStack {
                            Text(self.viewModel.stocksB[self.i].open).frame(width: 100, alignment: .trailing)
                            Text(self.viewModel.stocksB[self.i].high).frame(width: 100, alignment: .trailing)
                            Text(self.viewModel.stocksB[self.i].low).frame(width: 100, alignment: .trailing)
                            Text(self.viewModel.stocksB[self.i].close).frame(width: 100, alignment: .trailing)
                        }.frame(width: metrics.size.width * 0.24,alignment: .trailing).foregroundColor(.white).padding(5).background(self.stockB).cornerRadius(5)
                    }else{
                        VStack {
                            Text("-").frame(width: 100, alignment: .center)
                            Text("-").frame(width: 100, alignment: .center)
                            Text("-").frame(width: 100, alignment: .center)
                            Text("-").frame(width: 100, alignment: .center)
                        }.frame(width: metrics.size.width * 0.24,alignment: .trailing).foregroundColor(.white).padding(5).background(self.stockB).cornerRadius(5)
                    }
                    if self.viewModel.stocksC.count > 0 && self.i < self.viewModel.stocksC.count {
                        VStack {
                            Text(self.viewModel.stocksC[self.i].open).frame(width: 100, alignment: .trailing)
                            Text(self.viewModel.stocksC[self.i].high).frame(width: 100, alignment: .trailing)
                            Text(self.viewModel.stocksC[self.i].low).frame(width: 100, alignment: .trailing)
                            Text(self.viewModel.stocksC[self.i].close).frame(width: 100, alignment: .trailing)
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
                    if self.viewModel.higest().count > 0 {
                        Text(self.viewModel.higest()[self.i].date).frame(alignment: .center)
                    }else{
                        Text("-").frame(alignment: .center)
                    }
                }
            }
        }
    }
}

struct HeaderView: View {
    @ObservedObject var viewModel: CompareViewModel
    
    var stockA: Color
    var stockB: Color
    var stockC: Color

    var body: some View {
        GeometryReader { metrics in
            HStack{
                Spacer().frame(width: metrics.size.width * 0.2, alignment: .leading)
                Button(action: {
                    self.viewModel.fetch(tagStock: TagStock.A, symbol: "AAPL")
                    self.viewModel.buttonA = "AAPL"
                }) {
                    Text(self.viewModel.buttonA).bold().foregroundColor(.white)
                }.frame(width: metrics.size.width * 0.24, height: metrics.size.width * 0.2, alignment: .center)
                    .background(self.stockA).cornerRadius(10)
                Button(action: {
                    self.viewModel.fetch(tagStock: TagStock.B, symbol: "UNVR")
                    self.viewModel.buttonB = "UNVR"
                }) {
                    Text(self.viewModel.buttonB).bold().foregroundColor(.white)
                }.frame(width: metrics.size.width * 0.24, height: metrics.size.width * 0.2, alignment: .center)
                    .background(self.stockB).cornerRadius(10)
                Button(action: {
                    self.viewModel.fetch(tagStock: TagStock.C, symbol: "IBM")
                    self.viewModel.buttonC = "IBM"
                }) {
                    Text(self.viewModel.buttonC).bold().foregroundColor(.white)
                }.frame(width: metrics.size.width * 0.24, height: metrics.size.width * 0.2, alignment: .center)
                    .background(self.stockC).cornerRadius(10)
            }.frame(width: metrics.size.width, alignment: .center).padding(.top)
        }
    }
}

struct CompareView_Previews: PreviewProvider {
    static var previews: some View {
        CompareView(viewModel: CompareViewModel())
    }
}
