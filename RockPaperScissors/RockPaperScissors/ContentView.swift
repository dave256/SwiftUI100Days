//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by David M Reed on 10/20/19.
//  Copyright © 2019 David M Reed. All rights reserved.
//

import SwiftUI

enum Game: Int, RawRepresentable, CustomStringConvertible, Equatable {

    case rock
    case paper
    case scissors

    static var randomChoice: Game {
        let value = Int.random(in: 0...2)
        return Game(rawValue: value)!
    }

    var beats: Game {
        if rawValue == 0 {
            return Game(rawValue: 2)!
        } else {
            return Game(rawValue: ((self.rawValue - 1) % 3))!
        }
    }

    var losesTo: Game {
        Game(rawValue: ((self.rawValue + 1) % 3))!
    }

    var description: String {
        switch self {
        case .rock:
            return "Rock"
        case .paper:
            return "Paper"
        case .scissors:
            return "Scissors"
        }
    }

}

struct ContentView: View {
    @State private var computerTurn = Game.randomChoice
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var turnNumber = 1

    var message: String {
        if turnNumber <= 10 {
            return "Turn \(turnNumber)"
        } else {
            return "Score \(score)"
        }
    }

    var body: some View {
        VStack {
            if turnNumber <= 10 {
                Text(String(describing: computerTurn)).padding()
                Text(shouldWin ? "Win" : "Lose").padding()
                HStack {
                    Button(action: {
                        self.checkPlay(choice: Game.rock)
                    }) {
                        Text("Rock")
                    }

                    Button(action: {
                        self.checkPlay(choice: Game.paper)
                    }) {
                        Text("Paper")
                    }

                    Button(action: {
                        self.checkPlay(choice: Game.scissors)
                    }) {
                        Text("Scissors")
                    }
                }.padding()
            } else {
                Text("Game Over").padding()
                Text(message).padding()
                Button(action: {
                    self.score = 0
                    self.turnNumber = 1
                    self.startTurn()
                }) {
                    Text("Play again").padding()
                }
            }
        }
    }

    func checkPlay(choice: Game) {
        let correctChoice = shouldWin ? computerTurn.losesTo : computerTurn.beats
        if choice == correctChoice {
            score += 1
        } else {
            score -= 1
        }
        turnNumber += 1
        if turnNumber <= 10 {
            startTurn()
        }
    }

    func startTurn() {
        computerTurn = Game.randomChoice
        shouldWin = Bool.random()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
