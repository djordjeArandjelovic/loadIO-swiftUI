//
//  BOLPhotoActionsView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 2.7.24..
//

import SwiftUI

struct BOLPhotoActionsView: View {
    @Binding var selectedImages: [UIImage]
    @Binding var isPhotoLibraryPickerPresented: Bool
    @Binding var isCameraPickerPresented: Bool
    
    var body: some View {
        VStack {
            Text("BOL")
                .font(.largeTitle)
                .padding()
            Button(action: {
                isPhotoLibraryPickerPresented = true
            }) {
                Text("Browse Photos")
                    .frame(minWidth: 0, maxWidth: 200)
                    .padding()
                    .background(Color.indigo)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $isPhotoLibraryPickerPresented) {
                ImagePickerView(images: $selectedImages, sourceType: .photoLibrary)
            }
            Button(action: {
                isCameraPickerPresented = true
            }) {
                Text("Take a photo")
                    .frame(minWidth: 0, maxWidth: 200)
                    .padding()
                    .background(Color.indigo)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $isCameraPickerPresented) {
                ImagePickerView(images: $selectedImages, sourceType: .camera)
            }
        }
    }
}

#Preview {
    BOLPhotoActionsView(
            selectedImages: .constant([]),
            isPhotoLibraryPickerPresented: .constant(false),
            isCameraPickerPresented: .constant(false)
        )
}
