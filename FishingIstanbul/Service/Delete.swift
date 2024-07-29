//
//  Delete.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 27.07.2024.
//

import Foundation
import UIKit
import CoreData
protocol DeleteService {
    func delete(imageID : UUID, completion : @escaping(Result<Void,Error>) -> Void)
}


class Delete : DeleteService {
    
    func delete(imageID : UUID, completion : @escaping(Result<Void,Error>) -> Void){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", imageID.uuidString)
        fetchRequest.returnsObjectsAsFaults = false
        
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject]{
                    
                    if let id = result.value(forKey: "id") as? UUID{
                        
                        if id == imageID {
                            context.delete(result)
                          
                            do{
                                try context.save()
                                print("başarılı")
                                completion(.success(()))
                            
                            }catch{
                                print("kayıt hatası")
                                completion(.failure(NSError()))
                            }
                        }
                        
                    }
                }
                
            }
            
            
            
        }catch{
            print("delete error")
            completion(.failure(NSError()))
        }
        
    }
    
    
}
