//
//  ContentView.swift
//  UnitConverter
//
//  Created by David M Reed on 10/12/19.
//  Copyright © 2019 David M Reed. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var fromUnit = 0
    @State private var toUnit = 1
    @State private var valueString = "10.0"

    let units = TemperatureUnit.allCases.map { "\($0)" }

    private var convertedValue: Double {
        let value = Double(valueString) ?? 0.0
        let from = TemperatureUnit(rawValue: units[fromUnit])!
        let to = TemperatureUnit(rawValue: units[toUnit])!
        return TemperatureConversions.convert(value: value, from: from, to: to)
    }

    var body: some View {

        return NavigationView {
            Form {
                Section {
                    TextField("Value:", text: $valueString)
                        .keyboardType(.decimalPad)

                }
                Section(header: Text("Convert from:")) {
                    Picker("From Unit", selection: $fromUnit) {
                        ForEach(0 ..< units.count) {
                            Text("\(self.units[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }


                Section(header: Text("Convert to:")) {
                    Picker("To Unit", selection: $toUnit) {
                        ForEach(0 ..< units.count) {
                            Text("\(self.units[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())

                }

                Section {
                    Text("\(convertedValue)")
                }

            }.navigationBarTitle("Converter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
