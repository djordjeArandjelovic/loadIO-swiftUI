//
//  LoginView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 24.6.24..
//

import SwiftUI
import Combine

struct LoginView: View {
    
    @Binding var isUserLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var cancellable: AnyCancellable?
    @State private var loginFailed = false
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
                    login()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.indigo)
                .cornerRadius(5)
                
                if loginFailed {
                    Text("Login failed, please try again.")
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
        }
}

private extension LoginView {
    func login() {
        cancellable = NetworkService.shared.loginWithUsernameAndPassword(email: email, username: email, password: password)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    loginFailed = true
                    print("Login failed with error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { response in
                if response.isAuthSuccessful {
                    if let token = response.token {
                        NetworkService.shared.setToken(token)
                        print("Token set: \(token)")
                        isUserLoggedIn = true
                    } else {
                        print("No token received")
                        loginFailed = true
                    }
                } else {
                    loginFailed = true
                    print("Auth unsuccessful: \(response.errorMessage ?? "Unknown error")")
                }
            })
    }
}

#Preview {
    LoginView(isUserLoggedIn: .constant(false))
}
