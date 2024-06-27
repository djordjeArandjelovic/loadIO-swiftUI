//
//  ImagePickerView.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 27.6.24..
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    var sourceType: UIImagePickerController.SourceType
    
    init(images: Binding<[UIImage]> = .constant([]), sourceType: UIImagePickerController.SourceType = .photoLibrary) {
        _images = images
        self.sourceType = sourceType
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.images.append(uiImage)
            }
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    ImagePickerView()
}
