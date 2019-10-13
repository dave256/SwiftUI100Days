//
//  UnitConversions.swift
//  UnitConverter
//
//  Created by David M Reed on 10/12/19.
//  Copyright © 2019 David M Reed. All rights reserved.
//

import Foundation

// from: https://stackoverflow.com/questions/54455379/ios-swift-enum-caseiterable-extension
extension CaseIterable where Self: RawRepresentable {
    static var allValues: [RawValue] { allCases.map { $0.rawValue } }
}

enum UnitType: String, CaseIterable {
    case temperature = "Temperature"
    case length = "Length"
    case time = "Time"
    case volume = "Volume"

    /// return array of strings for each unit type
    var allValues: [String] {
        switch self {
        case .temperature:
            return TemperatureUnit.allValues
        case .length:
            return LengthUnit.allValues
        case .time:
            return TimeUnit.allValues
        case .volume:
            return VolumeUnit.allValues
        }
    }
}

enum TemperatureUnit: String, CaseIterable {
    case Celsius = "Celsius"
    case Fahrenheit = "Fahrenheit"
    case Kelvin = "Kelvin"
}

enum TimeUnit: String, CaseIterable {
    case seconds
    case minutes
    case hours
    case days
}

enum LengthUnit: String, CaseIterable {
    case meters
    case kilometers
    case feet
    case yards
    case miles
}

enum VolumeUnit: String, CaseIterable {
    case milliliters
    case liters
    case cups
    case pints
    case gallons
}

struct ConversionFactors {
    let multiplier: Double
    let offset: Double

    init(multiplier: Double, offset: Double = 0.0) {
        self.multiplier = multiplier
        self.offset = offset
    }
}

typealias FromToConversionFactors = (ConversionFactors, ConversionFactors)

struct Conversions {
    // convert (from unit to Celsius, from Celsius to unit)
    static var temperatureConversions : [String: FromToConversionFactors] = [
        TemperatureUnit.Celsius.rawValue : (ConversionFactors(multiplier: 1.0, offset: 0.0), ConversionFactors(multiplier: 1.0, offset: 0.0)),
        TemperatureUnit.Kelvin.rawValue : (ConversionFactors(multiplier: 1.0, offset: -273.0), ConversionFactors(multiplier: 1.0, offset: 273.0)),
        TemperatureUnit.Fahrenheit.rawValue: (ConversionFactors(multiplier: 5.0 / 9.0, offset: -5.0 / 9.0 * 32.0), ConversionFactors(multiplier: 9.0 / 5.0, offset: 32.0)),
    ]

    // convert (from unit to meters, meters to unit)
    static var lengthConversions: [String: FromToConversionFactors] = [
        LengthUnit.meters.rawValue : (ConversionFactors(multiplier: 1.0), ConversionFactors(multiplier: 1.0)),
        LengthUnit.kilometers.rawValue : (ConversionFactors(multiplier: 1000.0), ConversionFactors(multiplier: 1 / 1000.0)),
        LengthUnit.feet.rawValue : (ConversionFactors(multiplier: 1.0 / 3.2084), ConversionFactors(multiplier: 3.2084)),
        LengthUnit.yards.rawValue : (ConversionFactors(multiplier: 1.0 / 1.0931 ), ConversionFactors(multiplier: 1.0931)),
        LengthUnit.miles.rawValue : (ConversionFactors(multiplier: 1.0 / 0.0006213712), ConversionFactors(multiplier: 0.0006213712)),
    ]

     // convert (from unit to hours, hours to unit)
    static var timeConversions: [String: FromToConversionFactors] = [
        TimeUnit.seconds.rawValue: (ConversionFactors(multiplier: 1.0 / 3600), ConversionFactors(multiplier: 3600)),
        TimeUnit.minutes.rawValue: (ConversionFactors(multiplier: 1.0 / 60.0), ConversionFactors(multiplier: 60.0)),
        TimeUnit.hours.rawValue: (ConversionFactors(multiplier: 1.0), ConversionFactors(multiplier: 1.0)),
        TimeUnit.days.rawValue: (ConversionFactors(multiplier: 24.0), ConversionFactors(multiplier: 1 / 24.0))
    ]

    // convert (from unit to pints, pints to unit)
    static var volumeConversions: [String: FromToConversionFactors] = [
        VolumeUnit.milliliters.rawValue: (ConversionFactors(multiplier: 1.0 / 473.176), ConversionFactors(multiplier: 473.176)),
        VolumeUnit.liters.rawValue: (ConversionFactors(multiplier: 1.0 / 0.473176), ConversionFactors(multiplier: 0.473176)),
        VolumeUnit.cups.rawValue: (ConversionFactors(multiplier: 1.0 / 2.0), ConversionFactors(multiplier: 2.0)),
        VolumeUnit.pints.rawValue: (ConversionFactors(multiplier: 1.0), ConversionFactors(multiplier: 1.0)),
        VolumeUnit.gallons.rawValue: (ConversionFactors(multiplier: 1.0 / 0.125), ConversionFactors(multiplier: 0.125))
    ]

    /// dictionary of conversion factors for each unit type
    static var conversions: [String: [String: FromToConversionFactors]] = [
        UnitType.temperature.rawValue: temperatureConversions,
        UnitType.length.rawValue: lengthConversions,
        UnitType.time.rawValue: timeConversions,
        UnitType.volume.rawValue: volumeConversions
    ]

    static func convert(value: Double, unit: UnitType, fromUnit: String, toUnit: String) -> Double {
        guard let converters = Conversions.conversions[unit.rawValue], let fromConverters = converters[fromUnit], let toConverters = converters[toUnit] else {
            return 0.0
        }
        let fromConversion = fromConverters.0
        let toConversion = toConverters.1
        let intermediate = fromConversion.multiplier * value + fromConversion.offset
        return toConversion.multiplier * intermediate + toConversion.offset
    }
}

