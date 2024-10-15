//
//  LoadsView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 24.6.24..
//

import SwiftUI
import Combine

struct LoadsView: View {
    
    @Binding var loads: [SingleLoad]
    @Binding var isUserLoggedIn: Bool
    @State var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        NavigationStack {
            List(loads) { load in
                NavigationLink(destination: SingleLoadView(singleLoad: .constant(load))) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Load Number: \(load.loadNumber)")
                            .font(.headline)
                        Text("Route: \(load.route)")
                        Text("Mileage: \(String(format: "%.2f", load.mileage))")
                        if let pickupDate = load.pickupDate?.formattedDate() {
                            Text("Pickup Date: \(pickupDate)")
                        } else {
                            Text("Pickup Date: N/A")
                        }
                        if let deliveryDate = load.deliveryDate?.formattedDate() {
                            Text("Delivery Date: \(deliveryDate)")
                        } else {
                            Text("Delivery Date: N/A")
                        }
                        Text("$\(String(format: "%.2f", load.driverPayAmount))")
                        if let bolNum = load.bolNum {
                            HStack {
                                Text("BOL Uploaded: ")
                                Image(systemName: bolNum > 0 ? "checkmark" : "xmark")
                                    .foregroundStyle(bolNum > 0 ? .green : .red)
                            }
                        } else {
                            HStack {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundStyle(.yellow)
                                Text("BOL Information unavailable")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                    }
                }
                .padding([.top, .bottom])
            }
            .navigationTitle("Loads")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                print("Refreshed")
                fetchLoadsByDriver()
            }
        }
    }
}

private extension LoadsView {
    func fetchLoadsByDriver() {
        NetworkService.shared.fetchLoadsByDriver()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching loads: \(error)")
                }
            }, receiveValue: { loads in
                self.loads = loads
            })
            .store(in: &cancellables)
    }
}

#Preview {
    LoadsView(loads: .constant(SingleLoad.sampleData), isUserLoggedIn: .constant(true))
}
