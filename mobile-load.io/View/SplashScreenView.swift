//
//  SplashScreenView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 26.6.24..
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        VStack {
            Image("loadio-logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            Text("Your Road, Our Tech")
                .font(.title)
                .foregroundStyle(.indigo)
        }
    }
}

#Preview {
    SplashScreenView()
}
