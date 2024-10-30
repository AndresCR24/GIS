//
//  ContentView.swift
//  Gis
//
//  Created by Andres David Cardenas Ramirez on 17/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var loginShow: FirebaseViewModel
    @Binding var precio: String
    
    var body: some View {
        

        return Group {
            if loginShow.show {
                Home(precio: $precio)
                    .ignoresSafeArea(.all)
//                                    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
            }
            else {
                Login()
                //                    .preferredColorScheme(.light)
            }
        }
//        .onAppear() {
//            if (UserDefaults.standard.object(forKey: "sesion")) != nil {
//                loginShow.show = true
//            }
//            
//        }
        
    }
}
        
//    }
//}

