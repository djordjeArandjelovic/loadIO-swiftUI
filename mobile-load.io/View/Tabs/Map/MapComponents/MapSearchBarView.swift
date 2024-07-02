//
//  MapSearchBarView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 1.7.24..
//

import SwiftUI

struct MapSearchBarView: View {
    
    @Binding var text: String
    var placeholder: String
    var onCommit: () -> Void = {}
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField(placeholder, text: $text, onCommit: onCommit)
                .foregroundStyle(.primary)
                .textInputAutocapitalization(.never)
                .submitLabel(.search)
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal)
    }
}

#Preview {
    MapSearchBarView(text: .constant(""), placeholder: "Search...")
}
