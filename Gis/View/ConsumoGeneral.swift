import SwiftUI
import Charts
import Firebase

struct ConsumoGeneral: View {
    @StateObject private var viewModel = FirebaseViewModel() // Instancia del ViewModel
    @Binding var precio: String
    
    // Método para calcular el consumo de un solo electrodoméstico
    private func consumoElectrodomestico(potencia: Double, horasUso: Int, minutosUso: Int) -> Double {
        let totalHoras = Double(horasUso) + (Double(minutosUso) / 60.0)
        let potenciaEnKw = potencia / 1000.0
        let consumowh = potenciaEnKw * totalHoras
        return consumowh
    }
    
    var body: some View {
        ZStack {
            Color.fondo.ignoresSafeArea()
            VStack {
                Text("Consumo de cada Electrodoméstico")
                    .font(.largeTitle)
                    .padding()
                    .bold()
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.datosElectrodomesticos.unique(), id: \.id) { electrodomestico in
                            // Contenedor para cada electrodoméstico con un gráfico individual
                            VStack(alignment: .leading) {
                                Text(electrodomestico.nombre)
                                    .font(.title2)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 20)
                                    .padding(.top, 10)
                                
                                // Calcula el consumo para el gráfico
                                let consumo = consumoElectrodomestico(potencia: electrodomestico.potencia, horasUso: electrodomestico.horas, minutosUso: electrodomestico.minutos)
                                let precioDouble = Double(precio) ?? 0.0
                                
                                Chart {
                                    // Barra para consumo diario con texto debajo
                                    BarMark(
                                        x: .value("Tiempo de Uso", "Diario"),
                                        y: .value("Consumo (kWh)", consumo)
                                    )
                                    .annotation(position: .bottom) {
                                        Text("\(consumo * precioDouble, specifier: "%.2f") COP")
//                                            .font(.caption)
                                            .font(.system(size: 20))
                                            .offset(y: 35)
                                    }
                                    
                                    // Barra para consumo mensual con texto debajo
                                    BarMark(
                                        x: .value("Tiempo de Uso", "Mensual"),
                                        y: .value("Consumo (kWh)", consumo * 32)
                                    )
                                    .annotation(position: .bottom) {
                                        Text("\((consumo * 32) * precioDouble, specifier: "%.2f") COP")
                                            .font(.system(size: 20))
                                            .offset(y: 35)
                                    }
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
        }
        .onAppear {
            viewModel.getElectrodomesticos() // Cargar datos de electrodomésticos al aparecer la vista
        }
    }
}



//import SwiftUI
//import Charts
//import Firebase
//
//struct ConsumoGeneral: View {
//    @StateObject private var viewModel = FirebaseViewModel() // Instancia del ViewModel
//    @Binding var precio: String
//    // Método para calcular el consumo de un solo electrodoméstico
//    private func consumoElectrodomestico(potencia: Double, horasUso: Int, minutosUso: Int) -> Double {
//        let totalHoras = Double(horasUso) + (Double(minutosUso) / 60.0)
//        let potenciaEnKw = potencia / 1000.0
//        let consumowh = potenciaEnKw * totalHoras
//        return consumowh
//    }
//    
//    var body: some View {
//        ZStack{
//            Color.fondo.ignoresSafeArea()
//            VStack {
//                Text("Consumo de cada Electrodoméstico")
//                    .font(.largeTitle)
//                    .padding()
//                    .bold()
//                
//                ScrollView {
//                    VStack(spacing: 20) {
//                        ForEach(viewModel.datosElectrodomesticos.unique(), id: \.id) { electrodomestico in
//                            // Contenedor para cada electrodoméstico con un gráfico individual
//                            VStack(alignment: .leading) {
//                                Text(electrodomestico.nombre)
//                                    .font(.title2)
//                                    .padding(.bottom, 5)
//                                
//                                // Calcula el consumo para el gráfico
//                                let consumo = consumoElectrodomestico(potencia: electrodomestico.potencia, horasUso: electrodomestico.horas, minutosUso: electrodomestico.minutos)
//                                let precioDouble = Double(precio) ?? 0.0
//                                Chart {
//                                    BarMark(
//                                        x: .value("Tiempo de Uso", "Diario"),
//                                        y: .value("Consumo (kWh)", consumo)
//                                    )
//                                    BarMark(
//                                        x: .value("Tiempo de Uso", "Mensual"),
//                                        y: .value("Consumo (kWh)", consumo * 32)
//                                    )
//                                }
//                                .frame(height: 200)
//                                .padding()
//                                HStack {
//                                    Text("\(consumo * precioDouble, specifier: "%.2f") COP")
//                                    Text("\((consumo * 32) * precioDouble, specifier: "%.2f") COP")
//                                }
//                            }
//                            .background(Color.gray.opacity(0.1))
//                            .cornerRadius(10)
//                            .padding(.horizontal)
//                        }
//                    }
//                }
//            }
//        }
//        .onAppear {
//            viewModel.getElectrodomesticos() // Cargar datos de electrodomésticos al aparecer la vista
//        }
//    }
//}


