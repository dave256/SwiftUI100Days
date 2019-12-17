//
//  Mission.swift
//  MoonShot
//
//  Created by David M Reed on 12/16/19.
//  Copyright © 2019 David M Reed. All rights reserved.
//

import Foundation

struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }

    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String

    var displayName: String {
        "Apollo \(id)"
    }

    var image: String {
        "apollo\(id)"
    }

    var formattedLaunchDate: String {
        if let launchDate = launchDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: launchDate)
        } else {
            return "N/A"
        }
    }

    var crewLastNames: String {
        var names : [String] = []
        for c in crew {
            names.append(c.name.capitalized)
        }
        return names.joined(separator: ", ")
    }
}
