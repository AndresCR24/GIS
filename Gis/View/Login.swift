//
//  Login.swift
//
//  Created by Andres David Cardenas Ramirez on 30/08/24.
//

import SwiftUI

struct Login: View {
    
    @State private var email = ""
    @State private var password = ""
    @StateObject var login = FirebaseViewModel()
    @EnvironmentObject var loginShow: FirebaseViewModel
    var device = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        NavigationStack() {
            ZStack() {
                Color.fondo.ignoresSafeArea()
                VStack() {
                    Text("GIS")
                        .font(.largeTitle)
                        .foregroundStyle(.titulos)
                        .bold()
                    Image("logo")
                        .resizable()
                        .frame(height: 150)
                        .frame(width: 150)
                    
                    Text("Inicio de sesión")
                        .font(.largeTitle)
                        .foregroundStyle(.titulos)
                        .bold()
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .frame(width: device == .pad ? 700 : nil) // da el tamaño en ancho y largo a un texfield
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled(true)
                        .frame(width: device == .pad ? 700 : nil)
                        .padding(.bottom, 20)
                    Text("¿Olvido su contraseña?")
                        .font(.title3)
                        .foregroundStyle(.olvidoContraseña)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    Button(action: {
                        login.login(email: email, password: password) { done in
                            if done {
                                UserDefaults.standard.set(true, forKey: "sesion")
                                print("sesión guardada en UserDefaults")
                                loginShow.show.toggle()
                            }
                        }
                    }) {
                        Text("Iniciar sesión")
                            .font(.title)
                            .foregroundStyle(.white)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .frame(maxWidth: .infinity) // Ocupa todo el ancho disponible
                    
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Para asegurar que VStack ocupa todo el ancho y alto
                    .padding(.horizontal) // Espacio opcional a los lados del botón
                    
                    
                    
                    Text("Inicia sesion con")
                        .font(.title)
                        .foregroundStyle(.titulos)
                        .bold()
                    HStack {
                        Image(systemName: "apple.logo") // Utiliza el logo de Apple de SF Symbols
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20) // Ajusta el tamaño según sea necesario
                            .foregroundColor(.black)
                        
                        Button(action: {
                            login.login(email: email, password: password) { done in
                                if done {
                                    UserDefaults.standard.set(true, forKey: "sesion")
                                    print("seccion guardada en userDefaults")
                                    loginShow.show = true
                                }
                            }
                        }) {
                            Text("Apple")
                                .foregroundStyle(.black)
                                .padding(.trailing, 15)
                        }//Cierra boton
                        
                        Button(action: {
                            
                        }) {
                            Text("🄶oogle")
                                .foregroundStyle(.red)
                        }//Cierra boton
                        
                    }
                    Spacer()
                    //Divider()
                    Text("¿No tienes una cuenta?")
                        .font(.title3)
                        .foregroundStyle(.titulos)
                    NavigationLink(destination: Registro()) {
                        Text("Crea una cuenta")
                    }
                    //.bold()
                    //                Button(action: {
                    //                    login.createUser(email: email, password: password) { done in
                    //                        if done {
                    //                            UserDefaults.standard.set(true, forKey: "sesion")
                    //                            print("seccion guardada en userDefaults")
                    //                            loginShow.show.toggle()
                    //                        }
                    //                    }
                    //                }) {
                    //                    Text("Crea una cuenta")
                    //                        .font(.title)
                    //                    //.frame(width: 100)
                    //                        .foregroundStyle(.red)
                    //                        .padding(.vertical, 10)
                    //
                    //                }//Cierra boton
                    
                    
                }
                .padding()
            }
        }
    }
}
#Preview {
    Login()
}
