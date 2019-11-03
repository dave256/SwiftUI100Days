//
//  ContentView.swift
//  WordScramble
//
//  Created by David M Reed on 11/3/19.
//  Copyright © 2019 David M Reed. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word: Text:", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                List(usedWords, id: \.self) {
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                }
            }
        .navigationBarTitle(rootWord)
        }
    }

    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {
            return
        }

        // extra validation to come

        usedWords.insert(answer, at: 0)
        newWord = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
