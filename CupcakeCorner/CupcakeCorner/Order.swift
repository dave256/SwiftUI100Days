//
//  Order.swift
//  CupcakeCorner
//
//  Created by David M Reed on 12/18/19.
//  Copyright © 2019 David M Reed. All rights reserved.
//

import Combine

class BoxedOrder: ObservableObject {
    @Published var order = Order()
}

struct Order: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    var type = 0
    var quantity = 3

    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false

    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""

    var hasValidAddress: Bool {
        for field in [\Order.name, \Order.streetAddress, \Order.city, \Order.zip] {
            let trimmed = self[keyPath: field].trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty {
                return false
            }
        }
        return true
    }

    var cost: Double {
        var cost = Double(quantity) * 2
        cost += (Double(type) / 2)
        if extraFrosting {
            cost += Double(quantity)
        }
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        return cost
    }

}

class Order2: Codable {
    var name = ""
}
