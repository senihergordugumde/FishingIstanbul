//
//  Post.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 27.07.2024.
//

import Foundation
import UIKit
import CoreData

protocol PostService{
    func postImage(image : UIImage, completion: @escaping(Result<Void,Error>) -> Void)
}
    class Post : PostService {
        
        func postImage(image : UIImage, completion: @escaping(Result<Void,Error>) -> Void){
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            let newFishImage = NSEntityDescription.insertNewObject(forEntityName: "Images", into: context)
            
            let data = image.jpegData(compressionQuality: 0.5)
            newFishImage.setValue(UUID(), forKey: "id")
            
            newFishImage.setValue(data, forKey: "image")
            
            do{
                try context.save()
                print("başarılı")
                completion(.success(()))
                
            }catch{
                print("kayıt hatası")
                completion(.failure(NSError()))
            }
        }
        
        
        
        func imageToCloud(token: String, filename: String, content_type: String, byte_size: Int, checksum: String, completion: @escaping(Result<AIResponseModel, Error>) -> Void) {
            guard let url = URL(string: "https://api.fishial.ai/v1/recognition/upload") else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("\(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let parameters: [String: Any] = [
                "blob": [
                    "filename": filename,
                    "content_type": content_type,
                    "byte_size": byte_size,
                    "checksum": checksum
                ]
            ]

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = jsonData
            } catch {
                completion(.failure(error))
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError()))
                    return
                }
                
                do {
                    let model = try JSONDecoder().decode(AIResponseModel.self, from: data)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
        
        func uploadImage(model : AIResponseModel, image : Data, completion : @escaping(Result<Void,Error>) -> Void){
            let url = URL(string: model.directUpload.url)
            var request = URLRequest(url: url!)
            request.setValue(model.directUpload.headers.contentDisposition, forHTTPHeaderField: "Content-Disposition")
            request.setValue(model.directUpload.headers.contentMD5, forHTTPHeaderField: "Content-Md5")
            request.setValue("", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PUT"
            request.httpBody = image
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let data = data {
                    completion(.success(()))
                }
                
                if let error = error{
                    print(error.localizedDescription)
                    completion(.failure(NSError()))

                }
                
            }
            
            task.resume()
        }
        
        
        
        
        
        
        
 
}
