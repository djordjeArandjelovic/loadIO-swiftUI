//
//  TokenManager.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 1.7.24..
//

import Foundation

struct TokenManager {
    static let shared = TokenManager()
    private let tokenKey = "authToken"
    
    private init() {}
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: tokenKey)
        }
    }
}
