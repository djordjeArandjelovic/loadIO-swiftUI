//
//  SingleLoad.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 24.6.24..
//

import Foundation
import SwiftUI

class SingleLoad: Identifiable, Decodable {
    var id: Int
    var loadNumber: String
    var driverPayAmount: Double
    var mileage: Double
    var pickupDate: String?
    var deliveryDate: String?
    var bolNum: Int?
    var route: String
    var fileID: String?

    enum CodingKeys: String, CodingKey {
        case id = "load_ID"
        case loadNumber = "load_Number"
        case driverPayAmount = "driver_Pay_Amount"
        case mileage
        case pickupDate = "start_Date"
        case deliveryDate = "end_Date"
        case bolNum = "bol_Num"
        case route = "route"
        case fileID = "file_ID"
    }

    init(id: Int, loadNumber: String, driverPayAmount: Double, mileage: Double, pickupDate: String?, deliveryDate: String?, bolNum: Int?, route: String) {
        self.id = id
        self.loadNumber = loadNumber
        self.driverPayAmount = driverPayAmount
        self.mileage = mileage
        self.pickupDate = pickupDate
        self.deliveryDate = deliveryDate
        self.bolNum = bolNum
        self.route = route
    }
}

extension SingleLoad {
    static let sampleData: [SingleLoad] =
    [
        SingleLoad(id: 22342, loadNumber: "46262", driverPayAmount: 800.60, mileage: 762.25, pickupDate: "26.06.2024.", deliveryDate: "27.06.2024", bolNum: 1, route: "Seymour,IN-Woodridge,IL")
    ]
}
