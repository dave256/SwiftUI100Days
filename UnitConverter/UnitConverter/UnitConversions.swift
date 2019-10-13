//
//  UnitConversions.swift
//  UnitConverter
//
//  Created by David M Reed on 10/12/19.
//  Copyright © 2019 David M Reed. All rights reserved.
//

import Foundation

enum UnitType: String {
    case temperature = "Temperature"
    case length = "Length"
    case time = "Time"
    case volume = "Volume"
}

enum TemperatureUnit: String, CaseIterable {
    case Celsius = "Celsius"
    case Fahrenheit = "Fahrenheit"
    case Kelvin = "Kelvin"
}

struct TemperatureConversions {
    static func convert(value: Double, from: TemperatureUnit, to: TemperatureUnit) -> Double {
        let intermediate = convertToCelsius(value: value, from: from)
        return convertFromCelsius(value: intermediate, to: to)
    }

    private static func convertToCelsius(value: Double, from: TemperatureUnit) -> Double {
        switch from {
        case .Celsius:
            return value
        case .Fahrenheit:
            return 5.0 / 9.0 * (value - 32)
        case .Kelvin:
            return value - 273
        }
    }

    private static func convertFromCelsius(value: Double, to: TemperatureUnit) -> Double {
        switch to {

        case .Celsius:
            return value
        case .Fahrenheit:
            return 9.0 / 5.0 * value + 32.0
        case .Kelvin:
            return value + 273
        }
    }
}
