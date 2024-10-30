//
//  ImagePickerCoordinator.swift
//  Gis
//
//  Created by Andres David Cardenas Ramirez on 28/10/24.
//
import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage


class ImagePickerCoordinator: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    @Published var isImagePickerPresented: Bool = false
    
    func uploadImageToFirebase() {
        guard let image = selectedImage else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            print("Image uploaded successfully: \(metadata?.path ?? "")")
        }
    }
}

