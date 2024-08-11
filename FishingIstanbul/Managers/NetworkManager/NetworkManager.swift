//
//  NetworkManager.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 2.08.2024.
//

import Foundation
import UIKit
class NetworkManager {
    static let shared  = NetworkManager()
    private init(){}
    
    func downloadImage(with URLString : String, completion : @escaping(UIImage?) -> Void) {
        
        guard let url = URL(string: URLString) else { return  }
        var image : UIImage?
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
          
            guard let data = data else  { return }
           
                image = UIImage(data: data)
                print("date geldi")
                completion(image)
            }
         
         task.resume()
            
   
    }
    
    
    private func request<T: Decodable>(endpoint : Endpoint, completion : @escaping(Result<T,Error>)->Void){
 
        
        let task = URLSession.shared.dataTask(with: endpoint.request()) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
           
          
            /*
            guard let response = response as? HTTPURLResponse , response.statusCode >= 200 , response.statusCode <= 299 else {
                          completion(.failure(NSError(domain: "Invalid Response", code: 0)))
                          return
                      }
             */
           
   
            
            print(response)
            
            guard var data = data else {
                
                completion(.failure(NSError(domain: "Invalid Response data", code: 0)))
                return
            }
            
           
            do {
                if data.isEmpty {
                    data = "{}".data(using: .utf8)! //Nil dönen datayı json verisine çevirmemiz gerekiyor
                }
              
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            }
            
            catch{
                print("decode error")
                completion(.failure(NSError()))
            }
        }
        
        task.resume()
    }
    
    
    func getToken(completion : @escaping(Result<Token,Error>) -> Void ){
        let endPoint = Endpoint.getToken
        request(endpoint: endPoint, completion: completion)
    }
    
    func uploadPhoto(token: String, filename: String, content_type: String, byte_size: Int, checksum: String, completion : @escaping(Result<AIResponseModel,Error>) -> Void){
        let endPoint = Endpoint.uploadPhoto(token: token, filename: filename, content_type: content_type, byte_size: byte_size, checksum: checksum)
        
        request(endpoint: endPoint, completion: completion)
    
    }
    
    func putPhoto(model : AIResponseModel, image : Data, completion: @escaping(Result<EmptyResponse,Error>) -> Void){
        let endPoint = Endpoint.putPhoto(model: model, image: image)
        request(endpoint: endPoint, completion: completion)
    }
    
    func getRecognition(model : AIResponseModel, token : String, completion : @escaping(Result<FishResponse,Error>) -> Void){
        let endPoint = Endpoint.getRecognition(model: model, token: token)
        request(endpoint: endPoint, completion: completion)
    }
    
    
}
