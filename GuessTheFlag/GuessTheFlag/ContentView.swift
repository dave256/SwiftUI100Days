//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by David M Reed on 10/19/19.
//  Copyright © 2019 David M Reed. All rights reserved.
//

import SwiftUI

struct FlagImage: View {
    let imageName: String

    var body: some View {
        Image(imageName)
        .renderingMode(.original)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.black, lineWidth: 1))
        .shadow(color: .black, radius: 2)
    }
}

// https://talk.objc.io/episodes/S01E173-building-a-shake-animation
struct ShakeEffect: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: -30 * sin(position * 2 * .pi), y: 0))
    }

    init(shakes: Int) {
        position = CGFloat(shakes)
    }

    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var buttonTapped = false
    @State private var rotationAnimationAmount = 0.0
    @State private var opacityAmount = 1.0
    @State private var shakeTimes = 0

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            VStack {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        FlagImage(imageName: self.countries[number])
                    }.rotation3DEffect(Angle.degrees((number == self.correctAnswer && self.buttonTapped) ? self.rotationAnimationAmount : 0.0), axis: (x: CGFloat(0), y: CGFloat(1), z: CGFloat(0)))
                        .opacity((number != self.correctAnswer && self.buttonTapped) ? self.opacityAmount : 1.0)
                }
                Text("Score: \(score)").foregroundColor(.white)
                              .font(.largeTitle)
                              .fontWeight(.black)
                Spacer()
            }.modifier(ShakeEffect(shakes: self.shakeTimes))
                .animation(Animation.linear)
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message:
                Text("Your score is \(score)"),
                  dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                })
        }
    }

    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            withAnimation {
                self.rotationAnimationAmount = 720
                self.opacityAmount = 0.25
                self.buttonTapped = true
            }
            // need to reset so doesn't rotate again
            self.rotationAnimationAmount = 0

            // ask new question after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.askQuestion()
            }
        } else {
            shakeTimes = 3
            scoreTitle = "Wrong, that's the flag of \(countries[number])"
            withAnimation {
                self.buttonTapped = true
                self.shakeTimes = 3
            }
            // need to reset so doesn't shake again
            self.shakeTimes = 0

            // show correct answer after delay which will then ask question
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.showingScore = true
            }
        }
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        // reset values to start new question
        opacityAmount = 1.0
        buttonTapped = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
