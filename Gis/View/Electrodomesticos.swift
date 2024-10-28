import UIKit
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct Electrodomesticos: View {
    
    @State private var nombreElectrodomestico = ""
    @State private var potenciaElectrodomestico = ""
    @State private var casa = "casa1"
    @StateObject var guardar = FirebaseViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.fondo.ignoresSafeArea()
                VStack{
                    Image("logo")
                        .resizable()
                        .frame(height: 150)
                        .frame(width: 150)
                        .clipShape(Circle())
                    TextField("Nombre electrodoméstico", text: $nombreElectrodomestico)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.default)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    
                    TextField("Potencia en W", text: $potenciaElectrodomestico)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad) // Cambiar a tipo decimal para potencia
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    
                    Button(action: {
                        guardar.saveElectrodomestico(nombre: nombreElectrodomestico, potencia: potenciaElectrodomestico) { done in
                            if done {
                                nombreElectrodomestico = ""
                                potenciaElectrodomestico = ""
                            }
                        }
                    }) {
                        Text("Guardar")
                            .font(.title)
                            .foregroundStyle(.white)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .frame(maxWidth: .infinity)
                    .navigationTitle("Electrodomesticos")
                    .toolbar {
                        HStack{
                            NavigationLink(destination: ListaElectrodomesticos()){
                                Image(systemName: "pencil")
                            }
                            
                        }
                    }
                }
            }
        }
    }
}

//struct Electrodomesticos: View {
//
//    @State private var nombreElectrodomestico = ""
//    @State private var potenciaElectrodomestico = ""
//    @StateObject private var viewModel = FirebaseViewModel() // Instancia de FirebaseViewModel
//    var device = UIDevice.current.userInterfaceIdiom
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Color.fondo.ignoresSafeArea()
//                VStack {
//                    Image("logo")
//                        .resizable()
//                        .frame(height: 150)
//                        .frame(width: 150)
//                        .clipShape(Circle())
//
//                    TextField("Nombre electrodoméstico", text: $nombreElectrodomestico)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .keyboardType(.default)
//                        .autocorrectionDisabled(true)
//                        .textInputAutocapitalization(.never)
//                        .frame(width: device == .pad ? 700 : nil)
//
//                    TextField("Potencia en W", text: $potenciaElectrodomestico)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .keyboardType(.decimalPad) // Cambiar a tipo decimal para potencia
//                        .autocorrectionDisabled(true)
//                        .textInputAutocapitalization(.never)
//                        .frame(width: device == .pad ? 700 : nil)
//
//                    HStack {
//                        Button(action: {
//
//                        }) {
//                            Text("Guardar")
//                                .font(.title)
//                                .foregroundStyle(.white)
//                                .padding(.vertical, 10)
//                        }
//                        .buttonStyle(.borderedProminent)
//                        .tint(.blue)
//                        .frame(maxWidth: .infinity)
//                    }
//
//                    // Lista de electrodomésticos guardados
//                    List(viewModel.datos) { electrodomestico in
//                        VStack(alignment: .leading) {
//                            Text(electrodomestico.titulo)
//                                .font(.headline)
//                            Text("\(electrodomestico.descripcion) W")
//                                .font(.subheadline)
//                        }
//                    }
//                }
//                .padding()
//            }
//            .onAppear {
//                viewModel.getData(plataforma: "Electrodomesticos") // Reemplaza con la colección adecuada en Firestore
//            }
//        }
//    }
//}
