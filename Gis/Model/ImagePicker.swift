//
//  ImagePicker.swift
//  Gis
//
//  Created by Andres David Cardenas Ramirez on 28/10/24.
//
import SwiftUI
import PhotosUI
import Firebase

struct ImagePicker: View {
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage?

    var body: some View {
        PhotosPicker(
            selection: .init(get: { [] }, set: { newImages in
                guard let image = newImages.first else { return }
                Task {
                    if let data = try? await image.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                }
                isPresented = false
            }),
            matching: .images
        ) {
            Text("Seleccionar Imagen")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}
