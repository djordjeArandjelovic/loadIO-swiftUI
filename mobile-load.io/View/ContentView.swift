//
//  ContentView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 24.6.24..
//

import SwiftUI
import Combine

struct ContentView: View {
    var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoic3VwcG9ydEBsb2FkaW8uYXBwIiwiQ3VzdG9tZXJJZCI6IjUiLCJFbXBsb3llZUlkIjoiOCIsIlNlY3RvcklkIjoiMTYiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJWaWV3ZXIiLCJzdWIiOiIwNWI2ZTM1Ni04NGY4LTQ1MjEtOGI0OC1jOWQ1MjZiYTU4MGMiLCJleHAiOjE3MTk5MjgxMDcsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTAwMCIsImF1ZCI6IlRydWNraW5nVXNlcnMifQ.GCnhfcwuBQegPrNexg2qeNEzhiLnMYmuOqfWolQ95Ns"
    
    @State var selectedTab = 0
    @State var loads: [SingleLoad] = []
    @State var singleLoad: SingleLoad? = nil
    @State var cancellables = Set<AnyCancellable>()
    @State private var isLoading = true
    @Binding var isUserLoggedIn : Bool
    
    var body: some View {
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
                NetworkService.shared.setToken(token)
                fetchAllLoads()
            }
        }
    }
    
    private func fetchAllLoads() {
        NetworkService.shared.fetchAllLoads()
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
