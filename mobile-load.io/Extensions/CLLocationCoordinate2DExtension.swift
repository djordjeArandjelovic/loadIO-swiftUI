//
//  CLLocationCoordinate2DExtension.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 3.7.24..
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
