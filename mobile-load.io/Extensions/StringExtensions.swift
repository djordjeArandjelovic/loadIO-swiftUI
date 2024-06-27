//
//  StringExtensions.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 26.6.24..
//

import Foundation

extension String {
    func formattedDate(from originalFormat: String = "yyyy-MM-dd'T'HH:mm:ss", to desiredFormat: String = "MMM dd, yyyy") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = originalFormat
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = desiredFormat
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
