//
//  UserModel.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 25.6.24..
//

import Foundation
import SwiftUI

class UserModel: Identifiable {
    var id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String
    
    init(id: UUID, firstName: String, lastName: String, email: String, phoneNumber: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
    }
}

extension UserModel {
    static let sampleData: UserModel = UserModel(id: UUID(), firstName: "John", lastName: "Doe", email: "john@gmail.com", phoneNumber: "+1864728572")
}
