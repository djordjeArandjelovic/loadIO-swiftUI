//
//  DashboardView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 24.6.24..
//

import SwiftUI

struct DashboardView: View {
    
    @State private var rotationAngle: Double = 0
    @Binding var load: SingleLoad?
    
    var body: some View {
        ScrollView {
            if let load = load {
                
                VStack(spacing: 20) {
                    HStack(spacing: 20){
                        Text("Your Road")
                            .fontWeight(.semibold)
                            .foregroundStyle(.indigo)
                        Image("loadio-logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60 ,height: 30)
                            .rotationEffect(.degrees(rotationAngle))
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1)) {
                                    rotationAngle = 360
                                }
                            }
                        Text("Our Tech")
                            .fontWeight(.semibold)
                            .foregroundStyle(.indigo)
                    }
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        DashboardCardView(title: "Current Load", detail: load.loadNumber)
                    }
                }
                .padding()
                .padding(.vertical)
            }
//            else {
//                VStack {
//                    Image(systemName: "exclamationmark.triangle")
//                        .foregroundStyle(.yellow)
//                        .font(.system(size: 70))
//                    Text("Error loading current load...")
//                        .font(.largeTitle)
//                }
//            }
            
        }
    }
}


//VStack (alignment: .leading) {
//    Text("Load Number: \(load.loadNumber)")
//    Text("$\(String(format: "%.2f", load.driverPayAmount))")
//    Text("Mileage: \(String(format: "%.2f", load.mileage))")
//    if let pickupDate = load.pickupDate?.formattedDate() {
//        Text("Pickup Date: \(pickupDate)")
//    } else {
//        HStack {
//            Image(systemName: "exclamationmark.triangle")
//                .foregroundStyle(.yellow)
//            Text("Pickup Date: N/A")
//        }
//    }
//    if let deliveryDate = load.deliveryDate?.formattedDate() {
//        Text("Delivery Date: \(deliveryDate)")
//    } else {
//        HStack {
//            Image(systemName: "exclamationmark.triangle")
//                .foregroundStyle(.yellow)
//            Text("Pickup Date: N/A")
//        }
//    }
//    if let bolNum = load.bolNum {
//        Text("BOL Number: \(bolNum)")
//    } else {
//        Text("BOL Number: N/A")
//    }
//}

#Preview {
    DashboardView(load: .constant(SingleLoad.sampleData[0]))
}
