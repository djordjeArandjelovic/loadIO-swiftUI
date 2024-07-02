//
//  DashboardCardView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 30.6.24..
//

import SwiftUI

struct DashboardCardView: View {
    var title: String
    var detail: String
    let tileWidth: CGFloat = 170
    let tileHeight: CGFloat = 150
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            Text(detail)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .padding()
        .frame(width: tileWidth, height: tileHeight)
        .background(Color.indigo.opacity(0.40))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

#Preview {
    DashboardCardView(title: "Last Load", detail: "#12345")
}
