//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by David M Reed on 12/18/19.
//  Copyright © 2019 David M Reed. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var boxedOrder: BoxedOrder
    @State private var confirmationMessage = ""
    @State private var alertTitle = ""
    @State private var showingConfirmation = false

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)

                    Text("Your total is $\(self.boxedOrder.order.cost, specifier: "%.2f")")
                        .font(.title)

                    Button("Place Order") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .alert(isPresented: $showingConfirmation) {
            Alert(title: Text(alertTitle), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarTitle("Check out", displayMode: .inline)
    }

    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(boxedOrder.order) else {
            print("Failed to encode order")
            return
        }

        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                    self.alertTitle = "Thank you!"
                    self.confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                    self.showingConfirmation = true
                } else {
                    self.alertTitle = "Error"
                    self.confirmationMessage = "Invalid response from server"
                    self.showingConfirmation = true
                }
            } else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                   self.alertTitle = "Error"
                   self.confirmationMessage = "Error submitting order"
                   self.showingConfirmation = true
            }
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(boxedOrder: BoxedOrder())
    }
}
