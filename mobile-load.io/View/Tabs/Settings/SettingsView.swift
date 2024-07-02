//
//  SettingsView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 24.6.24..
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var isUserLoggedIn: Bool
    @State private var user: UserModel = UserModel.sampleData
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .imageScale(.large)
                        .frame(width: 100, height: 100)
                        .background(.indigo)
                        .clipShape(Circle())
                        .foregroundStyle(.white)
                        .padding(.vertical)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Driver name: ")
                                .foregroundColor(.gray)
                            Text("\(user.firstName) \(user.lastName)")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            Text("Email: ")
                                .foregroundColor(.gray)
                            Text(user.email)
                                .font(.subheadline)
                        }
                        
                        HStack {
                            Text("Phone number: ")
                                .foregroundColor(.gray)
                            Text(user.phoneNumber)
                                .font(.subheadline)
                        }
                    }
                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            
            // MARK: "FILES" Button is dedicated to a collection of important files that the driver might need
            // MARK: in case he gets pulled over or for any other reason. (registration, papers, licence...)
            Button(action: {
            }, label: {
                Text("Files")
                    .frame(minWidth: 0, maxWidth: 200)
                    .padding()
                    .background(Color.indigo)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            })
            .padding()
            
            Button(action: {
                isUserLoggedIn = false
            }, label: {
                Text("LogOut")
                    .frame(minWidth: 0, maxWidth: 200)
                    .padding()
                    .background(Color.indigo)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            })
            .padding()
        }
        .padding(.bottom)
    }
}

#Preview {
    SettingsView(isUserLoggedIn: .constant(true))
}
