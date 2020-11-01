//
//  SettingView.swift
//  WatchStock
//
//  Created by Bona Deny S on 10/30/20.
//  Copyright © 2020 Bona Deny S. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var viewModel: SettingViewModel
    
    @State private var f_apikey = ""
    @State private var f_interval = 0
    @State private var f_size = 0

    var body: some View {
        NavigationView {
            LoadingView(isShowing: .constant(self.viewModel.loading)) {
                GeometryReader { metrics in
                    VStack {
                        Form {
                            TextField("API Key", text:self.$f_apikey)
                            Picker(selection: self.$f_interval, label: Text("Interval")) {
                                Text("1 min").tag(0)
                                Text("5 min").tag(1)
                                Text("15 min").tag(2)
                                Text("30 min").tag(3)
                                Text("60 min").tag(4)
                            }
                            Picker(selection: self.$f_size, label: Text("Size")) {
                                Text("Compact").tag(0)
                                Text("Full").tag(1)
                            }
                        }
                        Button(action: {
                            self.viewModel.setPreference(self.f_apikey, self.viewModel.intervalList[self.f_interval], self.viewModel.sizeList[self.f_size])
                        }) {
                            Text("Apply")
                            }.frame(height: 5).padding()
                        Spacer()
                    }.navigationBarTitle(self.viewModel.title)
                }
            }.onAppear {
                if let receivedData = KeychainSwift().get(Query.apikey.rawValue) {
                    self.f_apikey = receivedData
                    print(receivedData)
                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(viewModel: SettingViewModel())
    }
}
