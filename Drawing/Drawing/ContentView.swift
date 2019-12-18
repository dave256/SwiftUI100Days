//
//  ContentView.swift
//  Drawing
//
//  Created by David M Reed on 12/18/19.
//  Copyright © 2019 David M Reed. All rights reserved.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}

struct Arrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.maxX - rect.minX
        let height = rect.maxY - rect.minY
        let arrowBottomY = rect.minY + 0.2 * height
        let arrowHalfWidth = 0.25 * width


        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: arrowBottomY))
        path.addLine(to: CGPoint(x: rect.maxX, y: arrowBottomY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.move(to: CGPoint(x: rect.midX - arrowHalfWidth, y: arrowBottomY))
        path.addLine(to: CGPoint(x: rect.midX - arrowHalfWidth, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + arrowHalfWidth, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + arrowHalfWidth, y: arrowBottomY))
        path.addLine(to: CGPoint(x: rect.midX - arrowHalfWidth, y: arrowBottomY))

        return path
    }
}

struct Flower: Shape {

    var petalOffset: Double = -20
    var petalWidth: Double = 100

    func path(in rect: CGRect) -> Path {

        var path = Path()

        for number in stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 8) {

            let rotation = CGAffineTransform(rotationAngle: number)

            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))

            let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset), y: 0, width: CGFloat(petalWidth), height: rect.width / 2))

            let rotatedPetal = originalPetal.applying(position)

            path.addPath(rotatedPetal)
        }
        return path
    }
}

struct Spirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: CGFloat

    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b

        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }

        return a
    }

    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        let outerRadius = CGFloat(self.outerRadius)
        let innerRadius = CGFloat(self.innerRadius)
        let distance = CGFloat(self.distance)
        let difference = innerRadius - outerRadius
        let endPoint = ceil(2 * CGFloat.pi * outerRadius / CGFloat(divisor)) * amount

        var path = Path()

        for theta in stride(from: 0, through: endPoint, by: 0.01) {
            var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
            var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)

            x += rect.width / 2
            y += rect.height / 2

            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        return path

    }
}

struct ContentView: View {

    @State private var lineWidth: CGFloat = 1.0

    var body: some View {
        VStack {
            ZStack {
                // make white rectangle around arrow so can use it for tap gesture (otherwise need to tap exactly on arrow border)
                Color(.white).frame(minWidth:180, maxWidth: .infinity, minHeight: 450, maxHeight: .infinity)
                .onTapGesture {
                    withAnimation {
                        // force random choice to be different by at least three from current value
                        if self.lineWidth < 10 {
                            self.lineWidth = CGFloat(Int.random(in: 12...20))
                        } else {
                            self.lineWidth = CGFloat(Int.random(in: 1...7))
                        }
                    }
                }
                Arrow().stroke(Color.red, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)).frame(width: 150, height: 400)

            }
            Slider(value: $lineWidth, in: 1...20)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
