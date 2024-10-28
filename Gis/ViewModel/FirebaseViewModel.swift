//
//  FirebaseViewModel.swift
//  Gis
//
//  Created by Andres David Cardenas Ramirez on 17/10/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirebaseViewModel: ObservableObject {
    
    @Published var show = false
    @Published var datos = [FirebaseModel]()
    @Published var itemUpdate: FirebaseModel!
    @Published var showEditar = false
    @Published var datosElectrodomesticos = [ElectrodomesticoModel]()
    
    
    @Published var nombreElectrodomestico: String = ""
    @Published var potenciaElectrodomestico: String = ""

    init() {
            // Cargar el estado de sesión desde UserDefaults
            self.show = UserDefaults.standard.bool(forKey: "sesion")
            print("Estado de sesión cargado: \(self.show)")
        }
    
    func sendData(item: FirebaseModel) {
        
        itemUpdate = item
        showEditar.toggle()
    }
    
    func login(email: String, password: String, completion: @escaping (_ done: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if user != nil {
                print("Entro")
                completion(true)
                UserDefaults.standard.set(true, forKey: "sesion")
            } else {
                if let error = error?.localizedDescription{
                    print("Error en firebase \(error)")
                }else {
                    print("Error en la app")
                }
                
            }
        }
    }
    //Base de datos
    
    //Guardar
    func save(titulo: String, descripcion: String, plataforma: String, portada: Data, completion: @escaping (_ done: Bool) -> Void) {
        
        let storage = Storage.storage().reference()
        let nombrePortada = UUID()
        let directorio = storage.child("imagenes/\(nombrePortada)")
        let metaData = StorageMetadata()
        
        metaData.contentType = "image/png"
        directorio.putData(portada, metadata: metaData) {data, error in
            if error == nil {
                print("Guardo la imagen")
                // Guardar Texto
                let db = Firestore.firestore()
                let id = UUID().uuidString
                
                guard let idUser = Auth.auth().currentUser?.uid else {return}
                guard let email = Auth.auth().currentUser?.email else {return}
                let campos: [String: Any] = ["titulo": titulo, "descripcion": descripcion, "portada": String(describing: directorio), "idUser": idUser, "email": email]
                
                db.collection(plataforma).document(id).setData(campos) {error in
                    if let error = error?.localizedDescription {
                        print("Error al guardar en firestore \(error)")
                    } else {
                        print("Guardo todo")
                        completion(true)
                    }
                }
                // Termino de guardar texto
            } else {
                if let error = error?.localizedDescription {
                    print("Fallo al subir la imagen en el storage \(error)")
                } else {
                    print("Fallo la app")
                }
            }
        }
        
    }
    
    
    func createUser(email: String, password: String, completion: @escaping (_ done: Bool) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if user != nil {
                print("Entro y se registro en firebase")
                completion(true)
            } else {
                if let error = error?.localizedDescription{
                    print("Error en firebase de registro \(error)")
                }else {
                    print("Error en la app")
                }
                
                
            }
        }
    }
    
    // Mostrar
    func getData(plataforma: String) {
        let db = Firestore.firestore()
        db.collection(plataforma).addSnapshotListener { QuerySnapshot, error in
            if let error = error?.localizedDescription {
                print("Error al mostrar datos \(error)")
            }else {
                self.datos.removeAll()
                for document in QuerySnapshot!.documents {
                    let valor = document.data()
                    let id = document.documentID
                    let titulo = valor["titulo"] as? String ?? "sin titulo"
                    let descripcion = valor["descripcion"] as? String ?? "sin descripcion"
                    let portada = valor["portada"] as? String ?? "sin portada"
                    
                    DispatchQueue.main.async {
                        let registros = FirebaseModel(id: id, titulo: titulo, descripcion: descripcion, portada: portada)
                        self.datos.append(registros)
                    }
                    
                }
            }
        }
    }
    //Eliminar
    func delete(index: FirebaseModel, plataforma: String) {
        //Eliminar de firestore
        let id = index.id
        let db = Firestore.firestore()
        db.collection(plataforma).document(id).delete()
        
        //Eliminar del storage
        let imagen = index.portada
        let borrarImagen = Storage.storage().reference(forURL: imagen)
        borrarImagen.delete(completion: nil)
    }
    //Editar
    func edit(titulo: String, descripcion: String, plataforma: String, id: String, completion: @escaping(_ done: Bool) -> Void) {
        
        let db = Firestore.firestore()
        let campos: [String:Any] = ["titulo" : titulo, "descripcion" : descripcion]
        
        db.collection(plataforma).document(id).updateData(campos) {error in
            
            if let error = error?.localizedDescription {
                print("Error al editar \(error)")
                
            }else {
                print("Edito solo el texto")
                completion(true)
            }
            
        }
    }
    
    //Editar con imagen
    func editWithImage(titulo: String, descripcion: String, plataforma: String, id: String, index: FirebaseModel, portada: Data,completion: @escaping(_ done: Bool) -> Void) {
        
        //Eliminar imagen
        let imagen = index.portada
        let borrarImagen = Storage.storage().reference(forURL: imagen)
        
        borrarImagen.delete(completion: nil)
        //Subir la imagen
        
        let storage = Storage.storage().reference()
        let nombrePortada = UUID()
        let directorio = storage.child("imagenes/\(nombrePortada)")
        let metaData = StorageMetadata()
        
        metaData.contentType = "image/png"
        directorio.putData(portada, metadata: metaData) {data, error in
            if error == nil {
                print("Guardo la imagen nueva")
                // Editando Texto
                let db = Firestore.firestore()
                let campos: [String:Any] = ["titulo" : titulo, "descripcion" : descripcion, "portada":String(describing : directorio)]
                
                db.collection(plataforma).document(id).updateData(campos) {error in
                    
                    if let error = error?.localizedDescription {
                        print("Error al editar \(error)")
                        
                    }else {
                        print("Edito solo el texto")
                        completion(true)
                    }
                }
                // Termino de guardar texto
            } else {
                if let error = error?.localizedDescription {
                    print("Fallo al subir la imagen en el storage \(error)")
                } else {
                    print("Fallo la app")
                }
            }
        }
    }
    // Inside your FirebaseViewModel
    
//    func saveElectrodomestico(electrodomestico: ElectrodomesticoModel, portada: Data, completion: @escaping (_ done: Bool) -> Void) {
//        
//        let storage = Storage.storage().reference()
//        let nombrePortada = UUID().uuidString // Usa UUID().uuidString para que sea una cadena
//        let directorio = storage.child("imagenes/\(nombrePortada)")
//        let metaData = StorageMetadata()
//        
//        metaData.contentType = "image/png"
//        directorio.putData(portada, metadata: metaData) { data, error in
//            if error == nil {
//                print("Guardo la imagen")
//                // Guardar Texto
//                let db = Firestore.firestore()
//                let id = UUID().uuidString
//                
//                guard let idUser = Auth.auth().currentUser?.uid else { return }
//                guard let email = Auth.auth().currentUser?.email else { return }
//                
//                // Utiliza las propiedades del modelo
//                let campos: [String: Any] = [
//                    "nombre": electrodomestico.nombre,
//                    "potencia": electrodomestico.potencia,
//                    "portada": String(describing: directorio),
//                    "idUser": idUser,
//                    "email": email
//                ]
//                
//                db.collection("Electrodomesticos").document(id).setData(campos) { error in
//                    if let error = error?.localizedDescription {
//                        print("Error al guardar en Firestore: \(error)")
//                    } else {
//                        print("Guardo todo")
//                        completion(true)
//                    }
//                }
//                // Fin de guardar texto
//            } else {
//                if let error = error?.localizedDescription {
//                    print("Fallo al subir la imagen en el storage: \(error)")
//                } else {
//                    print("Fallo la app")
//                }
//            }
//        }
//    }
    
//    func saveElectrodomestico(nombre: String, potencia: String, casa: String, completion: @escaping(_ done: Bool) -> Void) {
//        let db = Firestore.firestore()
//        let id = UUID().uuidString
//        
//        guard let idUser = Auth.auth().currentUser?.uid else { return }
//        
//        // Usar los parámetros nombre y potencia
//        let campos: [String: Any] = ["nombreElectrodomestico": nombre, "potenciaElectrodomestico": potencia, "idUser": idUser]
//        
//        db.collection(casa).document(id).setData(campos) { error in
//            if let error = error?.localizedDescription {
//                print("Error al guardar en firestore \(error)")
//            } else {
//                print("Guardado en Firestore")
//                completion(true)
//            }
//        }
//    }
    
    func saveElectrodomestico(nombre: String, potencia: String, completion: @escaping(_ done: Bool) -> Void) {
        let db = Firestore.firestore()
        let id = UUID().uuidString

        guard let idUser = Auth.auth().currentUser?.uid else {
            print("Error: Usuario no autenticado")
            completion(false)
            return
        }

        // Crear el diccionario de datos
        let campos: [String: Any] = [
            "nombreElectrodomestico": nombre,
            "potenciaElectrodomestico": potencia
        ]
        
        // Guardar el electrodoméstico en la subcolección de electrodomésticos del usuario
        db.collection("users").document(idUser).collection("electrodomesticos").document(id).setData(campos) { error in
            if let error = error {
                print("Error al guardar en Firestore: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Guardado en Firestore")
                completion(true)
            }
        }
    }

}
