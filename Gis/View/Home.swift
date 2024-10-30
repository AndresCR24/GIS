import SwiftUI
import Firebase
import Charts // Asegúrate de importar la biblioteca

struct Home: View {
    @Binding var precio:String 
    @State private var horasUso = 0
    @State private var minutosUso = 0
    @State private var selectedCurrency = "COP"
    @State private var isPickerVisible = false
    @StateObject private var viewModel = FirebaseViewModel()
    
    let currencies = ["COP", "USD", "EUR", "MXN", "BRL"]

    // Método para calcular el consumo de un solo electrodoméstico
    private func consumoElectrodomestico(potencia: Double, horasUso: Int, minutosUso: Int) -> Double {
        let totalHoras = Double(horasUso) + (Double(minutosUso) / 60.0)
        let potenciaEnKw = potencia / 1000.0
        let consumowh = potenciaEnKw * totalHoras
        return consumowh
    }

    // Método para calcular el consumo total de todos los electrodomésticos
    private func calcularConsumoTotal() -> Double {
        let consumoTotal = viewModel.datosElectrodomesticos.reduce(0.0) { total, electrodomestico in
            total + consumoElectrodomestico(potencia: electrodomestico.potencia, horasUso: electrodomestico.horas, minutosUso: electrodomestico.minutos)
        }
        return consumoTotal
    }
    
    // Método para calcular el costo total
    private func calcularCostoTotal(consumoTotal: Double) -> Double {
        guard let precioKwh = Double(precio) else { return 0.0 }
        return consumoTotal * precioKwh
    }
    
    // Método para obtener datos para el gráfico
    private func obtenerDatosGrafico() -> [(String, Double)] {
        return viewModel.datosElectrodomesticos.map { electrodomestico in
            let consumo = consumoElectrodomestico(potencia: electrodomestico.potencia, horasUso: electrodomestico.horas, minutosUso: electrodomestico.minutos)
            return (electrodomestico.nombre, consumo)
        }
    }

    var body: some View {
        ZStack {
            Color.fondo.ignoresSafeArea()
                .onTapGesture {
                    //n
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                }
            VStack {
                HStack{
                    Image("logo")
                        .resizable()
                        .frame(height:80)
                        .frame(width: 80)
                        .clipShape(Circle())
                        .frame(maxWidth: .infinity, alignment: .leading)
//                    Text("GIS")
//                        .font(.title)
//                        .bold()
//                        .foregroundStyle(.titulos)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    Spacer()
                }
                HStack {
                    
                    TextField("Precio Kwh", text: $precio)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)

                    if isPickerVisible {
                        Picker("Moneda", selection: $selectedCurrency) {
                            ForEach(currencies, id: \.self) { currency in
                                Text(currency)
                                    .foregroundColor(.black)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80)
                        .onChange(of: selectedCurrency) { _ in
                            isPickerVisible = false
                        }
                    } else {
                        Button(action: {
                            isPickerVisible = true
                        }) {
                            Text(selectedCurrency)
                                .frame(width: 80)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                        }
                    }
                }
                
//                Button(action: {
//                    // Acción para seleccionar un electrodoméstico
//                }) {
//                    Text("Seleccionar un electrodoméstico")
//                        .font(.title2)
//                        .foregroundStyle(.white)
//                        .padding(.vertical, 10)
//                }
//                .ignoresSafeArea()
//                .buttonStyle(.borderedProminent)
//                .tint(.titulos)
//                .frame(maxWidth: .infinity)
//                .padding(.horizontal)

                // Calcular el consumo total de todos los electrodomésticos
                let consumoTotal = calcularConsumoTotal()
                Text("Consumo Total por dia: \(consumoTotal, specifier: "%.2f") kWh")
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                Text("Consumo Total por mes: \(consumoTotal * 32, specifier: "%.2f") kWh")
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()

                // Calcular y mostrar el costo total
                let costoTotal = calcularCostoTotal(consumoTotal: consumoTotal)
                Text("Costo Total por dia: \(costoTotal, specifier: "%.2f") \(selectedCurrency)")
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()

                Text("Costo Total por mes: \(costoTotal * 32, specifier: "%.2f") \(selectedCurrency)")
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()

                // Gráfico del consumo
                let datosGrafico = obtenerDatosGrafico()
                Chart {
                    ForEach(datosGrafico, id: \.0) { nombre, consumo in
                        BarMark(
                            x: .value("Electrodoméstico", nombre),
                            y: .value("Consumo (kWh)", consumo * 32)
                        )
                    }
                }
                .frame(height: 300)
                .padding()
            }
            .padding()
            .onAppear {
                viewModel.getElectrodomesticos() // Cargar datos de electrodomésticos al aparecer la vista
            }
        }
    }
}

