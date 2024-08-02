//
//  Get.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 18.07.2024.
//

import Foundation
import FirebaseFirestore
import WeatherKit
import CoreLocation
import CoreData
protocol GetService{
    func getDams(completion : @escaping(Result<DamModel, Error>) -> Void)
    func getFishes(location : String, completion : @escaping(Result<[FishModel], Error>) -> Void)
    func getWeather(location : CLLocation, completion : @escaping(Result<Weather,Error>) -> Void)
    func fetchCoreData(completion : @escaping(Result<[ImageModel],Error>)->Void)
    func getRecognizeToken(completion : @escaping(String) -> Void)
    func getAIResponse(signedID: String, token: String, completion: @escaping (Result<[Species], Error>) -> Void)
}

class Get : GetService {
    
    
    
    
    func getWeather(location : CLLocation, completion : @escaping(Result<Weather,Error>) -> Void){
        let weatherKit = WeatherService()
        
        Task{
            do {
                let weather = try await weatherKit.weather(for: location)
                completion(.success(weather))
            }
            catch{
                print(error.localizedDescription)
                
                completion(.failure(NSError()))
            }
        }
    
    }
    
    func getDams(completion : @escaping(Result<
                                        DamModel, Error>) -> Void){
        
        let url = URL(string: "https://firestore.googleapis.com/v1/projects/baraj24v2/databases/(default)/documents/Dams/Istanbul/Baraj?key=AIzaSyDif8Uad6VNqtD9l5Pqd4_drl3pDBrcQLc")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            
            if let _ = error {
                
                print("HATA")
                completion(.failure(NSError()))
                
            }
            
            else if let data = data{
                
                let dam = try? JSONDecoder().decode(DamModel.self, from: data)
                
                
                if let dam = dam {
                    completion(.success(dam))
                }else{
                    print("Parse error")
                    completion(.failure(NSError()))
                }
                
            }
            
        }.resume()
        
    }
    
    
    func getFishes(location : String, completion : @escaping(Result<[FishModel], Error>) -> Void){
        
        let firestore = Firestore.firestore()
        
        firestore.collection("fishes").whereField("locations", arrayContains: location).addSnapshotListener { snap, error in
            
            guard let document = snap?.documents else{
                print("Döküman hatası")
                
                return
                
            }
            
            let fishes = document.compactMap { snap -> FishModel? in
                do {
                    let fish = try snap.data(as: FishModel.self)
                    return fish
                    
                } catch{
                    completion(.failure(NSError()))
                    return nil
                }
                
            }
            completion(.success(fishes))
        }
    }
    func fetchCoreData(completion : @escaping(Result<[ImageModel],Error>)->Void){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            let images = results.compactMap { image -> ImageModel? in
                guard let id = image.value(forKey: "id") as? UUID,
                      let imageData = image.value(forKey: "image") as? Data else{
                    return nil
                }
                
                return ImageModel(id: id, image: imageData)
                
            }
            
            completion(.success(images))
            
            
        }catch{
            print("resim alınamadı")
            completion(.failure(NSError()))
        }
    }
    
    
    func getRecognizeToken(completion : @escaping(String) -> Void){
        let url = URL(string: "https://api-users.fishial.ai/v1/auth/token")
        var createRequest = URLRequest(url: url!)
        createRequest.httpMethod = "POST"
        createRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let parameters: [String: Any] = [
            "client_id": "6bf8a1cbbe059b13ec37b510",
            "client_secret": "3707f77955263e52b9eda17befe16877"
        ]
        
        do{
            createRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            
        }catch{
            print("parametre dönüşüm hatası")
        }
        
        
        let task = URLSession.shared.dataTask(with: createRequest) { data, response, error in
           
            
            if let data = data {
                
                do{
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String:Any]{
                        
                        completion(json["access_token"] as! String)
                        
                    }
                } catch{
                    print("parse hatası")
                }
               
                
                
            }
            
        }
        task.resume()
        
    }
    

        func getAIResponse(signedID: String, token: String, completion: @escaping (Result<[Species], Error>) -> Void) {
            let baseUrl = "https://api.fishial.ai/v1/recognition/image?q="
            guard let url = URL(string: "\(baseUrl)\(signedID)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.setValue(token, forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    var speciesArray: [Species] = []
                    
                    if let results = json?["results"] as? [[String: Any]] {
                        for result in results {
                            if let speciesList = result["species"] as? [[String: Any]] {
                                for speciesDict in speciesList {
                                    if let name = speciesDict["name"] as? String {
                                        let species = Species(name: name)
                                        speciesArray.append(species)
                                    }
                                }
                            }
                        }
                    }
                    completion(.success(speciesArray))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }

}
