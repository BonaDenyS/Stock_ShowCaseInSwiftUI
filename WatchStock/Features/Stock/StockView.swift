//
//  StockView.swift
//  WatchStock
//
//  Created by Bona Deny S on 10/12/20.
//  Copyright © 2020 Bona Deny S. All rights reserved.
//

import SwiftUI

struct StockView: View {
    @ObservedObject var stockVM: StockViewModel
        
    var body: some View {
        NavigationView {
            LoadingView(isShowing: .constant(stockVM.loading)) {
                VStack {
                    SearchbarView(stockVM: self.stockVM)
                    List {
                        HStack {
                            Button(action: {
                                self.stockVM.byDate()
                            }){
                                Text("Date")
                                }.frame(width: 100, alignment: .leading).buttonStyle(BorderlessButtonStyle())
                            Button(action: {
                                self.stockVM.byOpen()
                            }){
                                Text("Open")
                            }.frame(width: 80, alignment: .trailing).buttonStyle(BorderlessButtonStyle())
                            Button(action: {
                                self.stockVM.byHigh()
                            }){
                                Text("High")
                                }.frame(width: 80, alignment: .trailing).buttonStyle(BorderlessButtonStyle())
                            Button(action: {
                                self.stockVM.byLow()
                            }){
                                Text("Low")
                                }.frame(width: 80, alignment: .trailing).buttonStyle(BorderlessButtonStyle())
                        }
                        ForEach(self.stockVM.stocks) { stock in
                            HStack {
                                Text(stock.date).frame(width: 100, height: 50, alignment: .trailing)
                                Text(stock.open).frame(width: 80, alignment: .trailing)
                                Text(stock.high).frame(width: 80, alignment: .trailing)
                                Text(stock.low).frame(width: 80, alignment: .trailing)
                            }
                        }
                    }
                }.navigationBarTitle(self.stockVM.title).onAppear() {
                    self.stockVM.fetch(symbol: self.stockVM.symbol)
                }
            }
        }
    }
}

struct SearchbarView: View {
    @ObservedObject var stockVM: StockViewModel
    
    @State private var showCancelButton: Bool = false
    @State private var searchText = ""
    
    var body: some View {
        HStack {
            HStack {
                Button(action: {
                    self.stockVM.fetch(symbol: self.searchText)
                }) {
                     Image(systemName: "magnifyingglass")
                }

                TextField("search", text: $searchText, onEditingChanged: { isEditing in
                    self.showCancelButton = true
                }, onCommit: {
                    self.stockVM.fetch(symbol: self.searchText)
                }).foregroundColor(.primary)

                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
                }.padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)

                if showCancelButton  {
                    Button("Cancel") {
                            UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                            self.searchText = ""
                            self.showCancelButton = false
                    }
                    .foregroundColor(Color(.systemBlue))
                }
            }.padding(.horizontal)
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView(stockVM: StockViewModel())
    }
}
