//
//  GisApp.swift
//  Gis
//
//  Created by Andres David Cardenas Ramirez on 17/10/24.
//
import SwiftUI


@main
struct GisApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var login = FirebaseViewModel() // Cambiado a @StateObject

    var body: some Scene {
        WindowGroup {
            NavigationView {
                TabViewMain()
                    .environmentObject(login) // Inyectar login como EnvironmentObject
            }
        }
    }
}

//@main
//struct GisApp: App {
//  // register app delegate for Firebase setup
//  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//
//  var body: some Scene {
//    let login = FirebaseViewModel()
//    WindowGroup {
//      NavigationView {
//        //ContentView()
//        //ContentView().environmentObject(login)
//        TabViewMain().environmentObject(login)
//      }
//    }
//  }
//}
