//
//  DocumentPickerCoordinator.swift
//  Gis
//
//  Created by Andres David Cardenas Ramirez on 28/10/24.
//
import SwiftUI
import UIKit

class DocumentPickerCoordinator: NSObject, ObservableObject, UIDocumentPickerDelegate {
    @Published var selectedDocumentURL: URL?

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        selectedDocumentURL = urls.first
    }
}
