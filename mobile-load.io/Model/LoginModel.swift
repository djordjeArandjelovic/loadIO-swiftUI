//
//  LoginModel.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 12.9.24..
//

import Foundation

struct LoginResponse: Codable {
    let isAuthSuccessful: Bool
    let token: String?
    let refreshToken: String?
    let errorMessage: String?
    let is2StepVerificationRequired: Bool
    let theme: Theme?
}

struct Theme: Codable {
    let id: Int
    let employeeId: Int
    let sidebarColor: String
    let mainColor: String
}
