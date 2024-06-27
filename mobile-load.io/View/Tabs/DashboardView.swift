//
//  DashboardView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 24.6.24..
//

import SwiftUI

struct DashboardView: View {
    
    @Binding var load: SingleLoad?
    
    var body: some View {
        VStack {
            if let load = load {
                Text("Load Details")
                    .font(.largeTitle)
                VStack (alignment: .leading) {
                    Text("Load Number: \(load.loadNumber)")
                    Text("$\(String(format: "%.2f", load.driverPayAmount))")
                    Text("Mileage: \(String(format: "%.2f", load.mileage))")
                    if let pickupDate = load.pickupDate?.formattedDate() {
                        Text("Pickup Date: \(pickupDate)")
                    } else {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundStyle(.yellow)
                            Text("Pickup Date: N/A")
                        }
                    }
                    if let deliveryDate = load.deliveryDate?.formattedDate() {
                        Text("Delivery Date: \(deliveryDate)")
                    } else {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundStyle(.yellow)
                            Text("Pickup Date: N/A")
                        }
                    }
                    if let bolNum = load.bolNum {
                        Text("BOL Number: \(bolNum)")
                    } else {
                        Text("BOL Number: N/A")
                    }
                }
            } else {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(.yellow)
                        .font(.system(size: 70))
                    Text("Error loading current load...")
                        .font(.largeTitle)
                }
            }
        }
        .padding()
    }
}

#Preview {
    DashboardView(load: .constant(nil))
}
