//
//  AstronautView.swift
//  MoonShot
//
//  Created by David M Reed on 12/16/19.
//  Copyright © 2019 David M Reed. All rights reserved.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    let missions: [Mission]

    init(astronaut: Astronaut, allMissions: [Mission]) {
        self.astronaut = astronaut

        var matches = [Mission]()

        for mission in allMissions {
            for crew in mission.crew {
                if crew.name == astronaut.id {
                    matches.append(mission)
                }
            }
        }
        self.missions = matches
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)

                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1)
                    List(self.missions) { mission in
                        Image(mission.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 44)

                        VStack(alignment: .leading) {
                            Text(mission.displayName)
                                .font(.headline)
                            Text(mission.formattedLaunchDate)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static let missions: [Mission] = Bundle.main.decode("missions.json")

    static var previews: some View {
        AstronautView(astronaut: astronauts[0], allMissions: missions)
    }
}
