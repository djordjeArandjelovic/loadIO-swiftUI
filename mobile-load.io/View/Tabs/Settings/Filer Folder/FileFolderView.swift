//
//  FileFolderView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 10.9.24..
//

import SwiftUI

struct FileFolderView: View {
    
    let files = ["Registration.pdf", "Insurance.pdf", "Driver's License.pdf", "Vehicle Papers.pdf"]
    
    var body: some View {
        VStack {
            Text("*Disclaimer*")
                .font(.headline)
                .padding(.top)
        }
        Text("*In case of bad internet connection please download files on your mobile phone in order to see them.*")
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        Spacer()
        List(files, id: \.self) { file in
            HStack {
                Image(systemName: "doc.fill")
                    .foregroundColor(.indigo)
                Text(file)
            }
        }
        .navigationTitle("Important Files")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        FileFolderView()
    }
}
