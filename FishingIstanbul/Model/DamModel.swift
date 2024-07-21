//
//  DamModel.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 18.07.2024.
//

import Foundation

struct DamModel: Codable {
    let documents: [Document]
}

// MARK: - Document
struct Document: Codable {
    let name: String
    let fields: Fields
    let createTime, updateTime: String
}

// MARK: - Fields
struct Fields: Codable {
    let damName: City
    let rate, longitude: Latitude
    let city: City
    let latitude: Latitude

    enum CodingKeys: String, CodingKey {
        case damName = "dam_name"
        case rate, longitude, city, latitude
    }
}

// MARK: - City
struct City: Codable {
    let stringValue: String
}

// MARK: - Latitude
struct Latitude: Codable {
    let doubleValue: Double
}

