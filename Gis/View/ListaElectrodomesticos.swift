import SwiftUI

struct ListaElectrodomesticos: View {
    @StateObject private var viewModel = FirebaseViewModel() // Instancia del ViewModel
    
    var body: some View {
        ZStack {
            Color.fondo.ignoresSafeArea() // Color de fondo
            
            VStack {
                Text("Lista de Electrodomésticos")
                    .font(.largeTitle)
                    .padding()
                
                List {
                    ForEach(viewModel.datosElectrodomesticos) { electrodomestico in
                        VStack(alignment: .leading) {
                            Text(electrodomestico.nombre) // Nombre del electrodoméstico
                                .font(.headline)
                            Text("\(electrodomestico.potencia) W") // Potencia del electrodoméstico
                                .font(.subheadline)
                            Text("\(electrodomestico.horas) horas, \(electrodomestico.minutos) minutos") // Horas y minutos
                                .font(.subheadline)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteElectrodomestico(electrodomestico: electrodomestico) // Asegúrate de que el tipo sea correcto
                            } label: {
                                Label("Eliminar", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle()) // Estilo de lista para que el fondo se vea mejor
                .background(Color.fondo) // Establecer el fondo de la lista
                .scrollContentBackground(.hidden) // Evitar que el fondo de la lista se muestre como blanco
            }
            .onAppear {
                viewModel.getElectrodomesticos() // Llamar a la función para obtener datos al aparecer la vista
            }
        }
    }
}
