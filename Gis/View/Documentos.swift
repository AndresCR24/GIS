//
//  Documentos.swift
//  Gis
//
//  Created by Andres David Cardenas Ramirez on 27/10/24.
//


//
//  Documentos.swift
//  Gis
//
//  Created by Andres David Cardenas Ramirez on 27/10/24.
//

import PhotosUI
import Firebase
import FirebaseStorage
import SwiftUI

// Función para obtener las URLs de las imágenes en Firebase Storage
func fetchImageURLs(completion: @escaping ([String]) -> Void) {
    let storageRef = Storage.storage().reference().child("images") // Referencia a la carpeta "images"
    var imageURLs: [String] = []

    storageRef.listAll { (result, error) in
        if let error = error {
            print("Error al listar imágenes: \(error.localizedDescription)")
            completion([])
            return
        }

        // Asegúrate de que result no es nil antes de acceder a items
        guard let result = result else {
            print("No se pudo obtener el resultado.")
            completion([])
            return
        }

        // Grupo de despacho para esperar a que todas las URLs se recuperen antes de llamar al completion
        let dispatchGroup = DispatchGroup()

        for item in result.items {
            dispatchGroup.enter()
            item.downloadURL { (url, error) in
                if let url = url {
                    imageURLs.append(url.absoluteString)
                } else {
                    print("Error al obtener URL: \(String(describing: error?.localizedDescription))")
                }
                dispatchGroup.leave()
            }
        }

        // Llama al completion cuando todas las URLs estén listas
        dispatchGroup.notify(queue: .main) {
            completion(imageURLs)
        }
    }
}

struct Documentos: View {
    @State private var imageUrls: [String] = [] // Almacena las URLs de las imágenes
    @StateObject private var imagePickerCoordinator = ImagePickerCoordinator()
    @State private var isModalPresented = false // Controla la presentación del modal
    @State private var hasFetchedURLs = false // Indica si ya se han obtenido las URLs

    var body: some View {
        ZStack {
            Color.fondo.ignoresSafeArea()
            ScrollView {
                VStack {
                    Text("Documentos")
                        .font(.largeTitle)
                        .padding()
                        .bold()
                        .foregroundStyle(.titulos)
                    Spacer()
                    Button(action: {
                        isModalPresented = true // Mostrar la ventana modal
                    }) {
                        Text("Cargar Documento")
                            .padding()
                            .background(Color.botones)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .sheet(isPresented: $isModalPresented) {
                        GuardarDocumento(imagePickerCoordinator: imagePickerCoordinator) // Muestra la ventana modal
                    }

                    ForEach(imageUrls, id: \.self) { url in
                        AsyncImage(url: URL(string: url)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            case .failure(let error):
                                //print("Error al cargar la imagen: \(error.localizedDescription)")
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                if !hasFetchedURLs {
                    fetchImageURLs { urls in
                        imageUrls = urls
                        hasFetchedURLs = true
                    }
                }
            }
        }
    }
}

// Preview para mostrar la vista
#Preview {
    Documentos()
}




//import PhotosUI
//import Firebase
//
//import SwiftUI
//
//struct Documentos: View {
//    @StateObject private var imagePickerCoordinator = ImagePickerCoordinator()
//    @State private var isModalPresented = false // Controla la presentación del modal
//
//    var body: some View {
//        ZStack{
//            Color.fondo.ignoresSafeArea()
//            VStack {
//                Text("En documentos")
//                    .font(.largeTitle)
//                    .padding()
//                
//                Button(action: {
//                    isModalPresented = true // Mostrar la ventana modal
//                }) {
//                    Text("Cargar Documento")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                .sheet(isPresented: $isModalPresented) {
//                    GuardarDocumento(imagePickerCoordinator: imagePickerCoordinator) // Muestra la ventana modal
//                }
//            }
//        }
//        //.padding()
//    }
//}
//
//#Preview {
//    Documentos()
//}




