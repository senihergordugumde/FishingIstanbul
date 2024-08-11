// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct FishResponse: Codable {
    let results: [Results]
}

// MARK: - Result
struct Results: Codable {
    let species: [Species]
}



// MARK: - Species
struct Species: Codable {

    let name : String
    let fishanglerData: FishanglerData
    
    enum CodingKeys: String, CodingKey {
        
           case fishanglerData = "fishangler-data"
           case name
   
       }
}

struct FishanglerData: Codable {
    let commonNames: [String]
    let family :String
}

