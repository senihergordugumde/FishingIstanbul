//
//  Endpoint.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 2.08.2024.
//

import Foundation

protocol EndpointProtocol {
    var baseUrl : String {get}
    var path : String {get}
    var method : HttpMethod {get}
    var header : [String : String]? {get}
    var parameters : [String : Any]? {get}
    func request () -> URLRequest
}

enum Endpoint {
    case getToken
    case uploadPhoto(token: String, filename: String, content_type: String, byte_size: Int, checksum: String)
    case putPhoto(model : AIResponseModel, image : Data)
    case getRecognition(model : AIResponseModel, token : String)
}


enum HttpMethod : String{
    case post = "POST"
    case put = "PUT"
    case get = "GET"
}


extension Endpoint : EndpointProtocol {
 
    
    var header: [String : String]? {
        switch self {
            
        case .getToken:
            let header : [String: String] = ["Content-Type" : "application/json"]
            return header
       
          
            
        case .getRecognition(_, token : let token):
            let header : [String : String] = ["Authorization" : "\(token)"]
            
            return header
      
           
        case .putPhoto(model: let model, image: _):
            let header : [String : String] = ["Content-Disposition" : model.directUpload.headers.contentDisposition,
                                              "Content-Md5": model.directUpload.headers.contentMD5,
                                              "Content-Type" : ""]
          
            
            return header
            
        case .uploadPhoto(token: let token, filename: let filename, content_type: let content_type, byte_size: let byte_size, checksum: let checksum):
            let header : [String : String] = [
                                              "Authorization" : "\(token)",
                                              "Content-Type" : "application/json"
            ]
            
            return header
        }
    }
    
    func request() -> URLRequest {
        var url: URL
        switch self {
            
                case .putPhoto(model: let model, _):
                    url = URL(string: model.directUpload.url)!
                default:
                    guard var components = URLComponents(string: baseUrl) else {
                        fatalError("URL Error")
                    }
                
                if case .getRecognition(let model, let token) = self {
                    components.queryItems = [URLQueryItem(name: "q", value: model.signedID)]
                }
            
                components.path = path
                    
                    url = components.url!
                    print(url)
                }
        
     /*
        guard var components = URLComponents(string: baseUrl) else {
                  fatalError("URL Error")
               }
               
        components.path = path */
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        switch self {
        case .putPhoto(_, image: let image):
            request.httpBody = image
            
        case .getToken, .uploadPhoto, .getRecognition:
            if let parameters = parameters {
                do {
                    let data = try JSONSerialization.data(withJSONObject: parameters)
                    request.httpBody = data
                } catch {
                    print("Parameter error: \(error)")
                }
            }
        }
        
        if let headers = header {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
    
    var parameters: [String : Any]? {
        switch self {
            
        case .getToken:
            
            let parameters: [String: Any] = [
                "client_id": "4b5165b982b393c9eef0e1c6",
                "client_secret": "2b297d690743e17a17d305b9dfff6b1d"
            ]
            
            return parameters
        
        case .putPhoto(_, image : _):
            
            return nil
        case .getRecognition:
            return nil
        case .uploadPhoto(_, filename: let filename, content_type: let content_type, byte_size: let byte_size, checksum: let checksum):
            let parameters: [String: Any] = [
                "blob": [
                    "filename": filename,
                    "content_type": content_type,
                    "byte_size": byte_size,
                    "checksum": checksum
                ]
            ]
            return parameters
        }
    }
    
    var method: HttpMethod {
        switch self {
            
        case .getToken:
            return .post
        case .uploadPhoto:
            return .post
        case .putPhoto:
            return .put
        case .getRecognition:
            return .get
        }
    }
    
    var baseUrl: String {
        switch self {
            
        case .getToken:
            return "https://api-users.fishial.ai"
        case .uploadPhoto:
            return "https://api.fishial.ai"
            
        case .getRecognition:
            return "https://api.fishial.ai"
        case .putPhoto(model: let model, image : _):
            return "\(model.directUpload.url)"
        }
        
    }
    
    var path: String {
        switch self {
            
        case .getToken:
            return "/v1/auth/token"
        case .uploadPhoto:
            return "/v1/recognition/upload"
        case .putPhoto:
            return ""

        case .getRecognition:
            return "/v1/recognition/image"
        }
        
        
      
        
    
}
    
}
