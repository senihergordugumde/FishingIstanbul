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
  
}
