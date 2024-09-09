//
//  MapView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 1.7.24..
//

import SwiftUI
import MapKit
import CoreLocation
import Combine

struct MapView: View {
    
    @StateObject private var locationManager = LocationManager()
    
    @State var region = MKCoordinateRegion(
        center: .init(latitude: 37.33182,longitude: -122.03118),
        span: .init(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    @State private var searchText: String = ""
    @State private var cancellables = Set<AnyCancellable>()
    @State private var timerCancellable: AnyCancellable?
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(
                coordinateRegion: $region,
                showsUserLocation: true
            )
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
            .onChange(of: locationManager.lastKnownLocation) { newLocation in
                guard let newLocation = newLocation else { return }
                sendCoordinates(latitude: newLocation.latitude, longitude: newLocation.longitude)
                region.center = newLocation
            }
            
            MapSearchBarView(text: $searchText, placeholder: "Search...", onCommit: searchMap)
                .shadow(radius: 10)
                .onSubmit {
                    searchMap()
                }
        }
    }
}

private extension MapView {
    func searchMap() {
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
    
    func startTimer() {
        timerCancellable = Timer.publish(every: 60.0, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
                if let location = locationManager.lastKnownLocation {
                    sendCoordinates(latitude: location.latitude, longitude: location.longitude)
                }
            }
    }
    
    func stopTimer() {
        timerCancellable?.cancel()
    }
    
    func sendCoordinates(latitude: Double, longitude: Double) {
        NetworkService.shared.sendCoordinates(latitude: latitude, longitude: longitude)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error sending coordinates: \(error)")
                }
            }, receiveValue: {
                print("Successfully sent coordinates")
            })
            .store(in: &cancellables)
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var lastKnownLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                self.lastKnownLocation = location.coordinate
            }
        }
    }
}

#Preview {
    MapView()
}
