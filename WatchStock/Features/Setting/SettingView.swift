//
//  SettingView.swift
//  WatchStock
//
//  Created by Bona Deny S on 10/30/20.
//  Copyright © 2020 Bona Deny S. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    let viewModel: SettingViewModel
    
    var body: some View {
        NavigationView {
            LoadingView(isShowing: .constant(self.viewModel.loading)) {
                GeometryReader { metrics in
                    VStack {
                        Text("Hello World")
                    }.navigationBarTitle(self.viewModel.title)
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
