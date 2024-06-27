//
//  mobile_load_ioApp.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 24.6.24..
//

import SwiftUI

@main
struct mobile_load_ioApp: App {
    
    @State private var isActive: Bool = false
    @State private var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isActive {
                if isLoggedIn {
                    ContentView(isUserLoggedIn: $isLoggedIn)
                } else {
                    LoginView(isUserLoggedIn: $isLoggedIn)
                }
            } else {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isActive = true
                            }
                        }
                    }
            }
        }
    }
}


//WindowGroup {
//    if isActive {
//        if isUserLoggedIn{
//            ContentView()
//        } else {
//            LoginView(isUserLoggedIn: $isUserLoggedIn)
//        }
//    } else {
//        SplashScreenView()
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                    withAnimation {
//                        isActive = true
//                    }
//                }
//            }
//    }
//}
