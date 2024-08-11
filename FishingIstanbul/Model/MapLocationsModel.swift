//
//  LocationsModel.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 6.08.2024.
//

import Foundation
import FirebaseFirestore
struct MapLocationsModel : Codable {
    var name : String
    var location : GeoPoint
    var image : String
}


