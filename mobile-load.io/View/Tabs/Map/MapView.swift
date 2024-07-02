//
//  MapView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 1.7.24..
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    
    let locationManager = CLLocationManager()
    
    @State var region = MKCoordinateRegion(
        center: .init(latitude: 37.334_900,longitude: -122.009_020),
        span: .init(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    @State private var searchText: String = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(
              coordinateRegion: $region,
              showsUserLocation: true,
              userTrackingMode: .constant(.follow)
            )
              .edgesIgnoringSafeArea(.top)
              .onAppear {
                  locationManager.requestWhenInUseAuthorization()
          }
            MapSearchBarView(text: $searchText, placeholder: "Search...", onCommit: searchMap)
                .shadow(radius: 10)
                .onSubmit {
                    searchMap()
                }
        }
    }
    
    private func searchMap() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error searching for places: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let mapItems = response.mapItems
            print("Found \(mapItems.count) places.")
            
            if let firstItem = mapItems.first {
                let coordinate = firstItem.placemark.coordinate
                print("Moving to coordinate: \(coordinate.latitude), \(coordinate.longitude)")
                region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                )
            }
        }
    }
}

#Preview {
    MapView()
}
