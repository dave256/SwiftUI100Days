//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by David M Reed on 12/18/19.
//  Copyright © 2019 David M Reed. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var boxedOrder = BoxedOrder()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $boxedOrder.order.type) {
                        ForEach(0..<Order.types.count, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }

                    Stepper(value: $boxedOrder.order.quantity, in: 3...20) {
                        Text("Number of cakes: \(boxedOrder.order.quantity)")
                    }
                }
                
                Section {
                    Toggle(isOn: $boxedOrder.order.specialRequestEnabled.animation()) {
                        Text("Any special requests?")
                    }

                    if boxedOrder.order.specialRequestEnabled {
                        Toggle(isOn: $boxedOrder.order.extraFrosting) {
                            Text("Add extra frosting")
                        }

                        Toggle(isOn: $boxedOrder.order.addSprinkles) {
                            Text("Add extra sprinkles")
                        }
                    }
                }

                Section {
                    NavigationLink(destination: AddressView(boxedOrder: boxedOrder)) {
                        Text("Delivery details")
                    }
                }

            }
            .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
