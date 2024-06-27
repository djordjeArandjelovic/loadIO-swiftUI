//
//  SingleLoadView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 24.6.24..
//

import SwiftUI
import Combine

struct SingleLoadView: View {
    
    @Binding var singleLoad: SingleLoad
    @State private var selectedImages: [UIImage] = []
    @State private var showImage: Bool = false
    @State var imagePickerSourceType: UIImagePickerController.SourceType = .camera
    @State private var isPhotoLibraryPickerPresented = false
    @State private var isCameraPickerPresented = false
    @State private var isDocumentPickerPresented = false
    @State private var uploadSuccess: Bool?
    @State private var cancellables = Set<AnyCancellable>()
    
    let uploadURL = URL(string: "https://dev.az.loadio.app/filemanager/PostFile?component_type=3&item_file_id=FILEID&file_sub_category=1)")!
    
    var body: some View {
        VStack (spacing: 50) {
            VStack {
                Text("Load Details")
                    .font(.largeTitle)
                Text("Load #: \(singleLoad.loadNumber)")
                Text("Route: \(singleLoad.route)")
                if let deliveryDate = singleLoad.deliveryDate?.formattedDate() {
                    Text("Delivery Date: \(deliveryDate)")
                } else {
                    Text("Delivery Date: N/A")
                }
            }
            
            //MARK: - Selected image preview
            if !selectedImages.isEmpty {
                VStack {
                    ForEach(0..<selectedImages.count, id: \.self) { index in
                        Image(uiImage: selectedImages[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .cornerRadius(10)
                            .padding(.bottom, 20)
                            .onTapGesture {
                                showImage = true
                            }
                            .fullScreenCover(isPresented: $showImage) {
                                FullScreenImageView(image: selectedImages[index]) {
                                    showImage = false
                                }
                            }
                    }
                    Button(action: {
                        uploadImages()
                    }) {
                        Text("Upload")
                            .frame(minWidth: 0, maxWidth: 200)
                            .padding()
                            .background(Color.indigo)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                    }
                }
            }
            
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
        .alert(isPresented: Binding<Bool>(
            get: { uploadSuccess != nil },
            set: { _ in uploadSuccess = nil }
        )) {
            if uploadSuccess == true {
                return Alert(title: Text("Success"), message: Text("Image uploaded successfully."), dismissButton: .default(Text("OK")))
            } else {
                return Alert(title: Text("Error"), message: Text("Failed to upload image."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    
    private func uploadImages() {
        guard let fileID = singleLoad.fileID,
              let url = URL(string: "https://dev.az.loadio.app/filemanager/PostFile?component_type=3&item_file_id=\(fileID)&file_sub_category=1") else {
            print("Invalid fileID or URL")
            return
        }
        
        NetworkService.shared.uploadImages(url: url, images: selectedImages)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error uploading images: \(error)")
                    uploadSuccess = false
                }
            }, receiveValue: {
                uploadSuccess = true
            })
            .store(in: &cancellables)
    }
}

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

#Preview {
    SingleLoadView(singleLoad: .constant(SingleLoad.sampleData[0]))
}
