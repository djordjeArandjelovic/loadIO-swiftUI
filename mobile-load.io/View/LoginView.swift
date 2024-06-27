//
//  LoginView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 24.6.24..
//

import SwiftUI

struct LoginView: View {
    
    @Binding var isUserLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State static var userlog: Bool = false
    
    var body: some View {
            VStack {
                Image("loadio-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                Text("Log In")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.indigo)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Log In") {
                    isUserLoggedIn = true
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.indigo)
                .cornerRadius(5)
            }
            .padding()
        }
}

#Preview {
    LoginView(isUserLoggedIn: .constant(false))
}
