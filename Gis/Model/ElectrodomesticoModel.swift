//
//  ElectrodomesticoModel.swift
//  Gis
//
//  Created by Andres David Cardenas Ramirez on 28/10/24.
//

import Foundation

struct ElectrodomesticoModel: Identifiable, Hashable {
    
    var id: String
    var nombre: String
    var potencia: Double
    var horas: Int
    var minutos: Int
}
