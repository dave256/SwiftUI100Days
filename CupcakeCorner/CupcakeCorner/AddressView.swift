//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by David M Reed on 12/18/19.
//  Copyright © 2019 David M Reed. All rights reserved.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var boxedOrder: BoxedOrder

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $boxedOrder.order.name)
                TextField("Street Address", text: $boxedOrder.order.streetAddress)
                TextField("City", text: $boxedOrder.order.city)
                TextField("Zip", text: $boxedOrder.order.zip)
            }

            Section {
                NavigationLink(destination: CheckoutView(boxedOrder: boxedOrder)) {
                    Text("Check out")
                }
            }
            .disabled(boxedOrder.order.hasValidAddress == false)
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(boxedOrder: BoxedOrder())
    }
}
