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
        VStack {
            Text("Load Details")
                .font(.largeTitle)
            Text("Load #: \(singleLoad.loadNumber)")
            Text("Route: \(singleLoad.route)")
            if let deliveryDate = singleLoad.deliveryDate?.formattedDate() {
                Text("Delivery Date: \(deliveryDate)")
            } else {
                Text("Delivery Date: N/A")
            }
        }
    }
}

#Preview {
    LoadDetailsView(singleLoad: .constant(SingleLoad.sampleData[0]))
}
