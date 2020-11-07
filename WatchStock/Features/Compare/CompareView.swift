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
    
    @State var selected = 0
    @State var search = ""
    @State var isSearching = false

    var body: some View {
        NavigationView {
            LoadingView(isShowing: .constant(self.viewModel.loading)) {
                PopupSearchView(viewModel: self.viewModel,
                                isSearching: self.$isSearching,
                                selected: self.$selected) {
                    GeometryReader { metrics in
                        VStack {
                            HStack {
                                HeaderView(viewModel: self.viewModel,
                                           symbol: self.$isSearching,
                                           stock: self.$selected,
                                           width: metrics.size.width)
                            }.frame(height: metrics.size.height * 0.15)
                            
                            List {
                                ForEach(0..<self.viewModel.higest().count, id: \.self) { iterator in
                                    VStack {
                                        BodyView(viewModel: self.viewModel,
                                                 titleConst: 0.18,
                                                 valueConst: 0.23,
                                                 index: iterator)
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
    
    @Binding var isSearching:Bool
    @Binding var selected: Int
    
    @State var searchText = ""
    @State var showCancelButton = false
        
    var content: () -> Content
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isSearching)
                    .blur(radius: self.isSearching ? 3 : 0)
                
                VStack {
                    ZStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.isSearching.toggle()
                            }) {
                                Image(systemName: "xmark.square")
                                    .frame(width: 30, height: 30, alignment: .center)
                            }
                        }
                        HStack {
                            Spacer()
                            Text("Search Symbol").foregroundColor(Color(#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1))).bold()
                            Spacer()
                        }
                    }
                    
                    Text("Please enter symbol to compare").foregroundColor(Color(#colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)))
                    HStack {
                        TextField("AAPL, UNVR, IBM etc...", text: self.$searchText, onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }, onCommit: {
                            self.viewModel.load(selected: &self.selected,
                                                symbol: &self.searchText,
                                                isLoading: &self.isSearching)
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
                        self.viewModel.load(selected: &self.selected,
                                            symbol: &self.searchText,
                                            isLoading: &self.isSearching)
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
                .opacity(self.isSearching ? 1 : 0)

            }
        }
    }
}

struct BodyView: View {
    @ObservedObject var viewModel: CompareViewModel
        
    let titleConst, valueConst: CGFloat
    let index: Int
    
    var body: some View {
        GeometryReader { metrics in
            VStack {
                HStack {
                    
                    CellViewTitle(width: metrics.size.width, const: self.titleConst)
                    
                    CellView(index: self.index,
                             stocks: self.viewModel.stocksA,
                             width: metrics.size.width,
                             const: self.valueConst,
                             background: Color("Stock List-1"))
                    CellView(index: self.index,
                             stocks: self.viewModel.stocksB,
                             width: metrics.size.width,
                             const: self.valueConst,
                             background: Color("Stock List-2"))
                    CellView(index: self.index,
                             stocks: self.viewModel.stocksC,
                             width: metrics.size.width,
                             const: self.valueConst,
                             background: Color("Stock List-3"))
                }
                HStack {
                    if self.viewModel.higest().count > 0 {
                        Text(self.viewModel.higest()[self.index].date).font(.system(size: 15)).frame(alignment: .center).padding(5)
                    }else{
                        Text("-").font(.system(size: 15)).frame(alignment: .center).padding(5)
                    }
                }
            }
        }
    }
}

struct CellViewTitle: View {
    
    let width, const: CGFloat
    
    var body: some View {
        VStack {
            Text("Open :").font(.subheadline).frame(width: width * const, alignment: .trailing)
            Text("High :").font(.subheadline).frame(width: width * const, alignment: .trailing)
            Text("Low :").font(.subheadline).frame(width: width * const, alignment: .trailing)
            Text("Close :").font(.subheadline).frame(width: width * const, alignment: .trailing)
        }.frame(width: width * const,alignment: .trailing)
    }
}

struct CellView: View {
    
    let index: Int
    let stocks: [Stock]
    let width, const: CGFloat
    let background: Color
    
    var body: some View {
        VStack {
            if stocks.count > 0 && index < stocks.count {
                VStack {
                    ValueCellView(text: stocks[index].open, width: width * const, alignment: .trailing)
                    ValueCellView(text: stocks[index].high, width: width * const, alignment: .trailing)
                    ValueCellView(text: stocks[index].low, width: width * const, alignment: .trailing)
                    ValueCellView(text: stocks[index].close, width: width * const, alignment: .trailing)
                }.frame(width: width * const,alignment: .trailing).foregroundColor(.white).padding(5).background(background).cornerRadius(5)
            }else{
                VStack {
                    ForEach(0..<4) { _ in
                        ValueCellView(text: "-", width: self.width * self.const, alignment: .center)
                    }
                }.frame(width: width * const,alignment: .trailing).foregroundColor(.white).padding(5).background(background).cornerRadius(5)
            }
        }
    }
}

struct ValueCellView: View {
    
    let text: String
    let width: CGFloat
    let alignment: Alignment
    
    var body: some View {
        Text(text).font(.system(size: 15)).frame(width: width, alignment: alignment)
    }
}

struct HeaderView: View {
    @ObservedObject var viewModel: CompareViewModel
    
    @Binding var symbol: Bool
    @Binding var stock:Int
    let width: CGFloat
    
    private static let const:CGFloat = 0.23

    var body: some View {
        GeometryReader { metrics in
            HStack{
                Spacer().frame(width: self.width * 0.18, alignment: .leading)
                ButtonStock(symbol: self.$symbol,
                            stock: self.$stock,
                            width: self.width * HeaderView.const,
                            height: self.width * HeaderView.const,
                            text: self.viewModel.buttonA,
                            background: Color("Stock List-1"),
                            index: 1)
                ButtonStock(symbol: self.$symbol,
                            stock: self.$stock,
                            width: self.width * HeaderView.const,
                            height: self.width * HeaderView.const,
                            text: self.viewModel.buttonB,
                            background: Color("Stock List-2"),
                            index: 2)
                ButtonStock(symbol: self.$symbol,
                            stock: self.$stock,
                            width: self.width * HeaderView.const,
                            height: self.width * HeaderView.const,
                            text: self.viewModel.buttonC,
                            background: Color("Stock List-3"),
                            index: 3)
            }.frame(width: metrics.size.width, alignment: .center).padding(.top)
        }
    }
}

struct ButtonStock: View {
    
    @Binding var symbol:Bool
    @Binding var stock: Int
    
    let width, height: CGFloat
    let text: String
    let background: Color
    let index:Int

    var body: some View {
        Button(action: {
            self.stock =  self.index
            self.symbol.toggle()
        }) {
            Text(text).bold().foregroundColor(.white)
        }.frame(width: width,
                height: height,
                alignment: .center).background(background).cornerRadius(10)
    }
}

struct CompareView_Previews: PreviewProvider {
    static var previews: some View {
        CompareView(viewModel: CompareViewModel())
    }
}
