//
//  SplashScreenView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 26.6.24..
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        VStack {
            Image("loadio-logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(rotationAngle))
                .onAppear {
                    withAnimation(.easeInOut(duration: 1)) {
                        rotationAngle = 360
                    }
                }
            Text("Your Road, Our Tech")
                .font(.title)
                .foregroundStyle(.indigo)
        }
    }
}

#Preview {
    SplashScreenView()
}
