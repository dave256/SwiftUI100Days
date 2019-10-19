//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by David M Reed on 10/19/19.
//  Copyright © 2019 David M Reed. All rights reserved.
//

import SwiftUI

struct LargeBlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
            .padding()
    }
}

extension View {
    func blueTitleStyle() -> some View {
        self.modifier(LargeBlueTitle())
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, World!").blueTitleStyle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
