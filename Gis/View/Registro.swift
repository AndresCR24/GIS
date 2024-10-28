import SwiftUI

struct Registro: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistered = false // Estado para activar el NavigationLink
    @StateObject var login = FirebaseViewModel()
    var device = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        ZStack {
            Color.fondo.ignoresSafeArea()
            VStack {
                Image("logo")
                    .resizable()
                    .frame(height: 150)
                    .frame(width: 150)
                
                Text("Registrarse")
                    .font(.largeTitle)
                    .foregroundStyle(.titulos)
                    .bold()
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .frame(width: device == .pad ? 700 : nil)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled(true)
                    .frame(width: device == .pad ? 700 : nil)
                    .padding(.bottom, 20)
                
                SecureField("Confirmar Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled(true)
                    .frame(width: device == .pad ? 700 : nil)
                    .padding(.bottom, 20)
                
                Button(action: {
                    login.createUser(email: email, password: password) { done in
                        if done {
                          
                            UserDefaults.standard.set(true, forKey: "sesion")
                            print("sección guardada en UserDefaults")
                            isRegistered = true // Activa el NavigationLink
                        }
                    }
                }) {
                    Text("Regístrate")
                        .font(.title)
                        .foregroundStyle(.red)
                        .padding(.vertical, 10)
                }
                .background(
                    NavigationLink(destination: Login(), isActive: $isRegistered) {
                        EmptyView()
                    }
                    .hidden() // Oculta el NavigationLink visualmente
                )
            }
            .navigationTitle("Registro")
            .padding()
        }
        
    }
}
