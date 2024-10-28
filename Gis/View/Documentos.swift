//
//  Documentos.swift
//  Gis
//
//  Created by Andres David Cardenas Ramirez on 27/10/24.
//

import SwiftUI

struct Documentos: View {
    @StateObject private var documentPickerCoordinator = DocumentPickerCoordinator()
    @State private var isPickerPresented = false

    var body: some View {
        VStack {
            if let documentURL = documentPickerCoordinator.selectedDocumentURL {
                Text("Documento seleccionado: \(documentURL.lastPathComponent)")
                    .padding()
            } else {
                Text("Ningún documento seleccionado")
                    .padding()
            }

            Button(action: {
                isPickerPresented.toggle()
            }) {
                Text("Cargar Documento")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .sheet(isPresented: $isPickerPresented) {
                DocumentPicker(coordinator: documentPickerCoordinator)
            }
        }
    }
}

#Preview {
    Documentos()
}

