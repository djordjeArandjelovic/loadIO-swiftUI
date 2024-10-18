//
//  LoadDetailsView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 2.7.24..
//


import SwiftUI

struct LoadDetailsView: View {
    @Binding var singleLoad: SingleLoad
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Load Details")
                .font(.largeTitle)
                .padding(.bottom, 10)
            
            HStack {
                Text("Load #:")
                    .fontWeight(.bold)
                Text(singleLoad.loadNumber)
            }
            
            HStack {
                Text("Route:")
                    .fontWeight(.bold)
                Text(singleLoad.route)
            }
            
            HStack {
                Text("Delivery Date:")
                    .fontWeight(.bold)
                if let deliveryDate = singleLoad.deliveryDate?.formattedDate() {
                    Text(deliveryDate)
                } else {
                    Text("N/A")
                }
            }
        }
        .padding()
    }
}

#Preview {
    LoadDetailsView(singleLoad: .constant(SingleLoad.sampleData[0]))
}
