//
//  ContentView.swift
//  WatchStock
//
//  Created by Bona Deny S on 10/10/20.
//  Copyright © 2020 Bona Deny S. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selected = 0
        
    var stockVM = StockViewModel()
    var compareVM = CompareViewModel()
    var settingVM = SettingViewModel()

    var body: some View {
        GeometryReader { metrics in
            VStack {
                if self.selected == 0 {
                    StockView(viewModel: self.stockVM)
                }else if self.selected == 1 {
                    CompareView(viewModel: self.compareVM)
                }else {
                    SettingView(viewModel: self.settingVM)
                }
                
                HStack {
                    Bottombar(selected: self.$selected).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                }.frame(height: metrics.size.height * 0.08)
                
            }
        }
    }
}

struct Bottombar: View {
    @Binding var selected: Int

    var body: some View {
        GeometryReader { metrics in
            HStack {
                Button(action: {
                    self.selected = 0
                }) {
                    VStack {
                        Image("stock").resizable().frame(width: 25, height: 25)
                        .background(self.selected == 0 ? Color.white : Color.clear)
                        Text("Stock").font(.custom("Helvetica", size:  12))
                    }
                }.frame(width: metrics.size.width / 3).foregroundColor(self.selected == 0 ? .blue : .gray)
                Button(action: {
                    self.selected = 1
                }) {
                    VStack {
                        Image("compare").resizable().frame(width: 25, height: 25)
                        .background(self.selected == 0 ? Color.white : Color.clear)
                        Text("Compare").font(.custom("Helvetica", size:  12))
                    }
                }.frame(width: metrics.size.width / 3).foregroundColor(self.selected == 1 ? .blue : .gray)
                Button(action: {
                    self.selected = 2
                }) {
                    VStack {
                        Image("setting").resizable().frame(width: 25, height: 25)
                        .background(self.selected == 0 ? Color.white : Color.clear)
                        Text("Setting").font(.custom("Helvetica", size:  12))
                    }
                }.frame(width: metrics.size.width / 3).foregroundColor(self.selected == 2 ? .blue : .gray)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
