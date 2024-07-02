//
//  DashboardView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 24.6.24..
//

import SwiftUI

struct DashboardView: View {
    
    @Binding var load: SingleLoad?
    
    var body: some View {
        ScrollView {
            if let load = load {
                
                VStack(spacing: 20) {
                    DashboardHeaderView()
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        DashboardCardView(title: "Current Load", detail: load.loadNumber)
                    }
                }
                .padding()
                .padding(.vertical)
            }
//            else {
//                VStack {
//                    Image(systemName: "exclamationmark.triangle")
//                        .foregroundStyle(.yellow)
//                        .font(.system(size: 70))
//                    Text("Error loading current load...")
//                        .font(.largeTitle)
//                }
//            }
            
        }
    }
}

#Preview {
    DashboardView(load: .constant(SingleLoad.sampleData[0]))
}
