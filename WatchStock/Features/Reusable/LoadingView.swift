//
//  LoadingView.swift
//  WatchStock
//
//  Created by Bona Deny S on 10/28/20.
//  Copyright © 2020 Bona Deny S. All rights reserved.
//

import SwiftUI

struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    ZStack {
                        ActivityIndicator().frame(width: 100, height: 100)
                        Text("Loading...").foregroundColor(.white).bold()
                    }
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }

}

struct ActivityIndicator: View {
    
    @State private var isAnimating: Bool = false
    
    let colors = [
                    Color.init(red: 79/255, green: 193/255, blue: 233/255),
                    Color.init(red: 236/255, green: 135/255, blue: 192/255),
                    Color.init(red: 172/255, green: 146/255, blue: 236/255)
                 ]
    @State var timer = 0
    
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            ForEach(0..<5) { index in
                Group {
                    Circle().foregroundColor(self.colors[self.timer % 3])
                        .frame(width: geometry.size.width / 5, height: geometry.size.height / 5)
                        .scaleEffect(!self.isAnimating ? 1 - CGFloat(index) / 5 : 0.2 + CGFloat(index) / 5)
                        .offset(y: geometry.size.width / 10 - geometry.size.height / 2)
                }.frame(width: geometry.size.width, height: geometry.size.height)
                    .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
                    .animation(Animation
                        .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
                        .repeatForever(autoreverses: false))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            self.isAnimating = true
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                self.timer += 1
            }
        }
    }
}

struct LoadingViewPreview: View {
    var body: some View {
        LoadingView(isShowing: .constant(true)) {
            VStack{
                Text("Hello World")
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingViewPreview()
    }
}
