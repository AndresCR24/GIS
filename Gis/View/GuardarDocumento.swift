import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage



struct GuardarDocumento: View {
    @ObservedObject var imagePickerCoordinator: ImagePickerCoordinator

    var body: some View {
        NavigationView {
            VStack {
                if let selectedImage = imagePickerCoordinator.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .padding()
                } else {
//                    Text("Selecciona una imagen")
//                        .padding()
                }

                Button(action: {
                    imagePickerCoordinator.isImagePickerPresented = true
                }) {
                    Text("Seleccionar Imagen")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $imagePickerCoordinator.isImagePickerPresented) {
                    ImagePicker(isPresented: $imagePickerCoordinator.isImagePickerPresented, selectedImage: $imagePickerCoordinator.selectedImage)
                }

                Button(action: {
                    imagePickerCoordinator.uploadImageToFirebase()
                    imagePickerCoordinator.selectedImage = nil
                }) {
                    Text("Guardar")
                        .padding()
                        .background(Color.botones)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Cargar Imagen")
//            .navigationBarItems(trailing: Button("Cerrar") {
////                imagePickerCoordinator.selectedImage = nil // Limpia la imagen seleccionada al cerrar
//            })
//            .padding()
        }
        .onAppear {
            imagePickerCoordinator.isImagePickerPresented = true // Abre automáticamente el ImagePicker
        }
    }
}
                                

