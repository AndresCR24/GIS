//
//  Perfil.swift
//  Gis
//
//  Created by Andres David Cardenas Ramirez on 28/10/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct Perfil: View {
    
    @EnvironmentObject var loginShow: FirebaseViewModel
    
    var body: some View {
        VStack{
            Text("En Perfil")
            
            Button(action: {
                try! Auth.auth().signOut()
                UserDefaults.standard.removeObject(forKey: "sesion")
                loginShow.show = false
            }) {
                Text("Salir")
                    .font(.title)
                    .frame(width: 200)
                    .foregroundStyle(.blue)
            }
            
        }
    }
}



#Preview {
    Perfil()
}
