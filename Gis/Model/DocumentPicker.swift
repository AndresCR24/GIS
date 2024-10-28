//
//  DocumentPicker.swift
//  Gis
//
//  Created by Andres David Cardenas Ramirez on 28/10/24.
//
import SwiftUI
import UIKit

struct DocumentPicker: UIViewControllerRepresentable {
    @ObservedObject var coordinator: DocumentPickerCoordinator

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .text, .image]) // Cambia los tipos de archivo según lo que necesites
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> DocumentPickerCoordinator {
        return coordinator
    }
}
