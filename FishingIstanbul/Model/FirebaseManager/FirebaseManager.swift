//
//  FirebaseManager.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 6.08.2024.
//

import Foundation
import FirebaseFirestore
class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    private init() {}
    
    private func request<T: Decodable>(path : Query, completion : @escaping(Result<[T],Error>)->Void){
        path.addSnapshotListener{ snap, error in
            
            
            guard let document = snap?.documents else{
                print("Döküman hatası")
                
                return
                
            }
        
            let results = document.compactMap { snap -> T? in
                do {
                    let result = try snap.data(as: T.self)
                    return result
                    
                } catch{
                    completion(.failure(NSError()))
                    return nil
                }
                
            }
            completion(.success(results))
        }
            
    }
    
    
    func getFishes(queryPath : Query, completion : @escaping(Result<[FishModel],Error>)->Void){
        request(path: queryPath, completion: completion)
    }
    
    
    func getMapLocations(queryPath : Query, completion : @escaping(Result<[MapLocationsModel],Error>) -> Void ){
        
        request(path: queryPath, completion: completion)
        
    }
}
