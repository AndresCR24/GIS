//
//  ListaElectrodomesticos.swift
//  Gis
//
//  Created by Andres David Cardenas Ramirez on 28/10/24.
//

import SwiftUI

struct ListaElectrodomesticos: View {
    @StateObject private var viewModel = FirebaseViewModel() // Instancia del ViewModel

    var body: some View {
        ZStack {
            Color.fondo.ignoresSafeArea()
           
                   
                    VStack {
                        Text("Lista de Electrodomésticos")
                            .font(.largeTitle)
                            .padding()
                        
                        List(viewModel.datos) { electrodomestico in
                            VStack(alignment: .leading) {
                                Text(electrodomestico.titulo) // Nombre del electrodoméstico
                                    .font(.headline)
                                Text("\(electrodomestico.descripcion) W") // Potencia del electrodoméstico
                                    .font(.subheadline)
                            }
                        }
                    }
                    .onAppear {
                        viewModel.getElectrodomestico() // Llamar a la función para obtener datos al aparecer la vista
                    }
                }
            }
        }
    


#Preview {
    ListaElectrodomesticos()
}
