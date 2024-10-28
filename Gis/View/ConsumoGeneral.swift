import SwiftUI
import Charts
import Firebase

struct ConsumoGeneral: View {
    @StateObject private var viewModel = FirebaseViewModel() // Instancia del ViewModel
    
    // Método para calcular el consumo de un solo electrodoméstico
    private func consumoElectrodomestico(potencia: Double, horasUso: Int, minutosUso: Int) -> Double {
        let totalHoras = Double(horasUso) + (Double(minutosUso) / 60.0)
        let potenciaEnKw = potencia / 1000.0
        let consumowh = potenciaEnKw * totalHoras
        return consumowh
    }
    
    var body: some View {
        VStack {
            Text("Consumo de cada Electrodoméstico")
                .font(.largeTitle)
                .padding()

            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.datosElectrodomesticos.unique(), id: \.id) { electrodomestico in
                        // Contenedor para cada electrodoméstico con un gráfico individual
                        VStack(alignment: .leading) {
                            Text(electrodomestico.nombre)
                                .font(.title2)
                                .padding(.bottom, 5)
                            
                            // Calcula el consumo para el gráfico
                            let consumo = consumoElectrodomestico(potencia: electrodomestico.potencia, horasUso: electrodomestico.horas, minutosUso: electrodomestico.minutos)
                            
                            Chart {
                                BarMark(
                                    x: .value("Tiempo de Uso", "Diario"),
                                    y: .value("Consumo (kWh)", consumo)
                                )
                                BarMark(
                                    x: .value("Tiempo de Uso", "Mensual"),
                                    y: .value("Consumo (kWh)", consumo * 30)
                                )
                            }
                            .frame(height: 200)
                            .padding()
                        }
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
            }
        }
        .onAppear {
            viewModel.getElectrodomesticos() // Cargar datos de electrodomésticos al aparecer la vista
        }
    }
}

#Preview {
    ConsumoGeneral()
}
