//
//  TabViewMain.swift
//  Gis
//
//  Created by Andres David Cardenas Ramirez on 27/10/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct TabViewMain: View {
    @StateObject var login = FirebaseViewModel()
    @EnvironmentObject var loginShow: FirebaseViewModel
    //@Binding var precio: Double
    @State private var precio: String = "854"
    
    var body: some View {
        // Verifica si el usuario está autenticado
        if loginShow.show == false{
            Login()
            
        }
        else {
            TabView {
                ContentView(precio: $precio).tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                
                Electrodomesticos().tabItem {
                    Label("Electrodomésticos", systemImage: "plus")
                }
                
                ConsumoGeneral(precio: $precio).tabItem {
                    Label("Consumo General", systemImage: "chart.bar.xaxis")
                }

                Documentos().tabItem {
                    Label("Documentos", systemImage: "document")
                }
                
                Perfil().tabItem {
                    Label("Perfil", systemImage: "person")
                }
            }
        }
    }
}



