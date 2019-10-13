//
//  ContentView.swift
//  UnitConverter
//
//  Created by David M Reed on 10/12/19.
//  Copyright © 2019 David M Reed. All rights reserved.
//

import SwiftUI

struct ConverterView: View {
    var unitType: UnitType
    @State private var valueString: String = "0.0"

    @State private var fromUnitIndex = 0
    @State private var toUnitIndex = 0

    var convertedValue: Double {
        let unitNames = unitType.allValues
        let originalValue = Double(valueString) ?? 0.0
        guard fromUnitIndex < unitNames.count, toUnitIndex < unitNames.count else {
            return 0.0
        }
        let from = unitNames[fromUnitIndex]
        let to = unitNames[toUnitIndex]
        return Conversions.convert(value: originalValue, unit: unitType, fromUnit: from, toUnit: to)
    }

    var body: some View {
        let unitNames = unitType.allValues
        return Group {
            Section(header: Text("From: ")) {
                Picker("From: ", selection: $fromUnitIndex) {
                    ForEach(0..<unitNames.count, id: \.self) {
                        Text(unitNames[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            Section(header: Text("To: ")) {
                Picker("To: ", selection: $toUnitIndex) {
                    ForEach(0..<unitNames.count, id: \.self) {
                        Text(unitNames[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            Section(header: Text("Value: ")) {
                TextField("value", text: $valueString)
            }.keyboardType(.decimalPad)
            Section(header: Text("Converted value: ")) {
                Text("\(convertedValue, specifier: "%.3f")")
            }
        }
    }
}

struct ContentView: View {
    @State private var unitPickerIndex = 0

    let units = UnitType.allCases.map { "\($0.rawValue)" }

    var body: some View {

        return NavigationView {
            Form {
                Section(header: Text("Unit Type")) {
                    Picker("Unit Type", selection: $unitPickerIndex) {
                        ForEach(0 ..< units.count) {
                            Text("\(self.units[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                ConverterView(unitType: UnitType.allCases[unitPickerIndex])
            }.navigationBarTitle("Converter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
