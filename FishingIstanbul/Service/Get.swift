//
//  Get.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 18.07.2024.
//

import Foundation


protocol GetService{
    func getDams(completion : @escaping(Result<DamModel, Error>) -> Void)
}

class Get : GetService {
   
   
    
 
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
    
}
