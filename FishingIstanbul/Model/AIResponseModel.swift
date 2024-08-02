// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct AIResponseModel: Codable {
     let id: Int
     let key, filename, contentType: String
     let byteSize: Int
     let checksum, createdAt, serviceName, signedID: String
     let directUpload: DirectUpload

     enum CodingKeys: String, CodingKey {
         case id, key, filename
         case contentType = "content-type"
         case byteSize = "byte-size"
         case checksum
         case createdAt = "created-at"
         case serviceName = "service-name"
         case signedID = "signed-id"
         case directUpload = "direct-upload"
     }
}

struct DirectUpload: Codable {
    let url: String
    let headers: Headers
}


struct Headers: Codable {
    let contentMD5, contentDisposition: String

    enum CodingKeys: String, CodingKey {
        case contentMD5 = "Content-MD5"
        case contentDisposition = "Content-Disposition"
    }
}
