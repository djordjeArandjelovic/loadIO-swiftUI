//
//  ContentView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 24.6.24..
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State var selectedTab = 0
    @State var loads: [SingleLoad] = []
    @State var singleLoad: SingleLoad? = nil
    @State var cancellables = Set<AnyCancellable>()
    @State private var isLoading = true
    @Binding var isUserLoggedIn : Bool
    
    var body: some View {
//        Image("logoLight")
//            .resizable()
//            .scaledToFit()
//            .frame(width: 100, height: 50)
        Group {
            if isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                    .scaleEffect(1.5, anchor: .center)
            } else {
                TabView(selection: $selectedTab) {
                    DashboardView(load: $singleLoad)
                        .tag(0)
                        .tabItem {
                            Image(systemName: "circle.dashed")
                            Text("Dashboard")
                        }
                    LoadsView(loads: $loads, isUserLoggedIn: $isUserLoggedIn)
                        .tag(1)
                        .tabItem {
                            Image(systemName: "truck.box")
                            Text("Loads")
                        }
                    MapView()
                        .tag(2)
                        .tabItem {
                            Image(systemName: "map")
                            Text("Map")
                        }
                    SettingsView(isUserLoggedIn: $isUserLoggedIn)
                        .tag(3)
                        .tabItem {
                            Image(systemName: "slider.horizontal.3")
                            Text("Settings")
                        }
                }
                .accentColor(.indigo)
            }
        }
        .onAppear {
            Task {
                if NetworkService.shared.hasToken {
                    print("Token found, fetching loads")
                    fetchLoadsByDriver()
                } else {
                    print("No token found, not fetching loads")
                }
            }
        }
    }
    
    private func fetchLoadsByDriver() {
        NetworkService.shared.fetchLoadsByDriver()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching loads: \(error)")
                }
                isLoading = false
            }, receiveValue: { loads in
                self.loads = loads
                if let firstLoad = loads.first {
                    self.fetchLoadDetail(loadID: firstLoad.id)
                }
            })
            .store(in: &cancellables)
    }
    
    private func fetchLoadDetail(loadID: Int) {
        NetworkService.shared.fetchLoadDetail(loadID: loadID)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching load detail: \(error)")
                }
            }, receiveValue: { load in
                self.singleLoad = load
            })
            .store(in: &cancellables)
    }
}

#Preview {
    ContentView(isUserLoggedIn: .constant(true))
}
