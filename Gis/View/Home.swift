//
//  Home.swift
//  Gis
//
//  Created by Andres David Cardenas Ramirez on 27/10/24.
//

import SwiftUI

struct Home: View {
    @State private var precio = ""
    @State private var horasUso = 1 // Inicializa con 1 hora
    @State private var minutosUso = 0 // Inicializa con 0 minutos
    @State private var selectedCurrency = "COP" // Moneda por defecto
    @State private var isPickerVisible = false // Controla la visibilidad del Picker
    let currencies = ["COP", "USD", "EUR", "MXN", "BRL"] // Lista de monedas
    let horas = Array(0...24) // Array de horas de 1 a 24
    let minutos = Array(0...59) // Array de minutos de 0 a 59

    var body: some View {
        ZStack {
            Color.fondo.ignoresSafeArea()
            VStack {
                HStack {
                    TextField("Precio Kwh", text: $precio)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    
                    // Solo muestra el Picker si isPickerVisible es verdadero
                    if isPickerVisible {
                        Picker("Moneda", selection: $selectedCurrency) {
                            ForEach(currencies, id: \.self) { currency in
                                Text(currency)
                                    .foregroundColor(.black) // Cambia el color del texto a negro
                            }
                        }
                        .pickerStyle(WheelPickerStyle()) // Opcional: muestra el picker como menú desplegable
                        .frame(width: 80) // Ajusta el ancho del picker según lo necesario
                        .onChange(of: selectedCurrency) { _ in
                            isPickerVisible = false // Oculta el picker al seleccionar una moneda
                        }
                    } else {
                        Button(action: {
                            isPickerVisible = true // Muestra el picker al presionar el botón
                        }) {
                            Text(selectedCurrency) // Muestra la moneda seleccionada
                                .frame(width: 80)
                                .background(Color.gray.opacity(0.2)) // Estilo del botón
                                .cornerRadius(5)
                        }
                    }
                }
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
                    
                }) {
                    Text("Seleccionar un electrodomestico")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                }//Cierra boton
                .ignoresSafeArea()
                .buttonStyle(.borderedProminent)
                .tint(.titulos)
                .frame(maxWidth: .infinity) // Ocupa todo el ancho disponible
                .padding(.horizontal)
                //Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    Home()
}
