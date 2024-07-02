//
//  DashboardHeaderView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 2.7.24..
//

import SwiftUI

struct DashboardHeaderView: View {
    
    @State var rotationAngle: Double = 0
    
    var body: some View {
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
    }
}

#Preview {
    DashboardHeaderView()
}
