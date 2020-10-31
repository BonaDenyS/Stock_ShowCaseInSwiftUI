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
    
    @State var stock = 0
    @State var search = ""
    @State var searchSymbol = false
    
    let stockA = Color.init(red: 79/255, green: 193/255, blue: 233/255)
    let stockB = Color.init(red: 236/255, green: 135/255, blue: 192/255)
    let stockC = Color.init(red: 172/255, green: 146/255, blue: 236/255)

    var body: some View {
        NavigationView {
            LoadingView(isShowing: .constant(self.viewModel.loading)) {
                PopupSearchView(viewModel: self.viewModel, isShowing: self.$searchSymbol, stock: self.$stock) {
                    GeometryReader { metrics in
                        VStack {
                            HStack {
                                HeaderView(viewModel: self.viewModel, searchSymbol: self.$searchSymbol, stock: self.$stock, stockA: self.stockA, stockB: self.stockB, stockC: self.stockC)
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
}

struct PopupSearchView<Content>: View where Content: View {

    @ObservedObject var viewModel: CompareViewModel
    
    @Binding var isShowing:Bool
    @Binding var stock: Int
    
    @State var searchText = ""
    @State var showCancelButton = false
        
    var content: () -> Content
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)
                
                VStack {
                    ZStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.isShowing.toggle()
                            }) {
                                Image(systemName: "xmark.square")
                                    .frame(width: 30, height: 30, alignment: .center)
                            }
                        }
                        HStack {
                            Spacer()
                            Text("Search Symbol").foregroundColor(Color(red: 50/255, green: 50/255, blue: 50/255)).bold()
                            Spacer()
                        }
                    }
                    Text("Please enter symbol to compare").foregroundColor(Color(red: 100/255, green: 100/255, blue: 100/255))
                    HStack {
                        TextField("AAPL, UNVR, IBM etc...", text: self.$searchText, onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }, onCommit: {
                            switch self.stock {
                                case 1 :
                                    self.viewModel.fetch(tagStock: TagStock.A, symbol: self.searchText)
                                        self.viewModel.buttonA = self.searchText
                                        self.stock = 0
                                    break
                                case 2 :
                                    self.viewModel.fetch(tagStock: TagStock.B, symbol: self.searchText)
                                    self.viewModel.buttonB = self.searchText
                                    self.stock = 0
                                break
                                case 3 :
                                    self.viewModel.fetch(tagStock: TagStock.C, symbol: self.searchText)
                                    self.viewModel.buttonC = self.searchText
                                    self.stock = 0
                                break
                                default: break
                            }
                            self.searchText = ""
                            self.isShowing.toggle()
                            }).foregroundColor(.primary).multilineTextAlignment(.center)

                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(self.searchText == "" ? 0 : 1)
                        }
                    }.padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                        .foregroundColor(.secondary)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10.0)
                    Button(action: {
                        switch self.stock {
                            case 1 :
                                self.viewModel.fetch(tagStock: TagStock.A, symbol: self.searchText)
                                    self.viewModel.buttonA = self.searchText
                                    self.stock = 0
                                break
                            case 2 :
                                self.viewModel.fetch(tagStock: TagStock.B, symbol: self.searchText)
                                self.viewModel.buttonB = self.searchText
                                self.stock = 0
                            break
                            case 3 :
                                self.viewModel.fetch(tagStock: TagStock.C, symbol: self.searchText)
                                self.viewModel.buttonC = self.searchText
                                self.stock = 0
                            break
                            default: break
                        }
                        self.searchText = ""
                        self.isShowing.toggle()
                    }) {
                        HStack{
                            Spacer()
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                            Spacer()
                        }
                    }.padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)
                    
                }.padding(EdgeInsets(top: 5, leading: 15, bottom: 15, trailing: 15))
                .frame(width: geometry.size.width / 1.2,
                       height: geometry.size.height / 3)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)

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
    
    @Binding var searchSymbol: Bool
    @Binding var stock:Int
    
    var stockA: Color
    var stockB: Color
    var stockC: Color

    var body: some View {
        GeometryReader { metrics in
            HStack{
                Spacer().frame(width: metrics.size.width * 0.2, alignment: .leading)
                Button(action: {
                    self.stock =  1
                    self.searchSymbol.toggle()
                }) {
                    Text(self.viewModel.buttonA).bold().foregroundColor(.white)
                }.frame(width: metrics.size.width * 0.24, height: metrics.size.width * 0.2, alignment: .center)
                    .background(self.stockA).cornerRadius(10)
                Button(action: {
                    self.stock =  2
                    self.searchSymbol.toggle()
                }) {
                    Text(self.viewModel.buttonB).bold().foregroundColor(.white)
                }.frame(width: metrics.size.width * 0.24, height: metrics.size.width * 0.2, alignment: .center)
                    .background(self.stockB).cornerRadius(10)
                Button(action: {
                    self.stock =  3
                    self.searchSymbol.toggle()
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
