import UIKit
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct Electrodomesticos: View {
    
    @State private var precio = ""
    @State private var horasUso = 1 // Inicializa con 1 hora
    @State private var minutosUso = 0 // Inicializa con 0 minutos
    @State private var selectedCurrency = "COP" // Moneda por defecto
    @State private var isPickerVisible = false // Controla la visibilidad del Picker
    let currencies = ["COP", "USD", "EUR", "MXN", "BRL"] // Lista de monedas
    let horas = Array(0...24) // Array de horas de 1 a 24
    let minutos = Array(0...59) // Array de minutos de 0 a 59
    
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
                    Text("Tiempo de uso")
                        .font(.title3)
                        .foregroundStyle(.olvidoContraseña)
                        .bold()
                        //.frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("Horas")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Picker("Horas", selection: $horasUso) {
                            ForEach(horas, id: \.self) { hour in
                                Text("\(hour)").foregroundColor(.black) // Cambia el color del texto a negro
                            }
                        }
                        .pickerStyle(MenuPickerStyle()) // Estilo del Picker
                        //.frame(width: 80) // Ajusta el ancho del picker según lo necesario
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Minutos")
                        Picker("Minutos", selection: $minutosUso) {
                            ForEach(minutos, id: \.self) { minute in
                                Text("\(minute)").foregroundColor(.black) // Cambia el color del texto a negro
                            }
                        }
                        .pickerStyle(MenuPickerStyle()) // Estilo del Picker
                        .frame(width: 80) // Ajusta el ancho del picker según lo necesario
                    }
                    
                    Button(action: {
                        guardar.saveElectrodomestico(nombre: nombreElectrodomestico, potencia: potenciaElectrodomestico, horas: horasUso, minutos: minutosUso) { done in
                            if done {
                                nombreElectrodomestico = ""
                                potenciaElectrodomestico = ""
                                horasUso = 0
                                minutosUso = 0
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
