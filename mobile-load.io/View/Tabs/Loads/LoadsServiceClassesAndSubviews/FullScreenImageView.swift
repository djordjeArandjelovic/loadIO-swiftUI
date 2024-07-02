//
//  FullScreenImageView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 2.7.24..
//

import SwiftUI

struct FullScreenImageView: View {
    var image: UIImage
    var onDismiss: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button(action: onDismiss) {
                    Text("Back")
                }
                Spacer()
            }
            .padding()
            Spacer()
            
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .edgesIgnoringSafeArea(.all)
            Spacer()
        }
    }
}
