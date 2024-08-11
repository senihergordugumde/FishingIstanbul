//
//  RegionDetailsViewModel.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 7.08.2024.
//

import Foundation
import MapKit
import FirebaseFirestore

protocol RegionDetailsViewModelDelegate : AnyObject {
    func updateFishes()
    func updateImage(image : UIImage)
}


class RegionDetailsViewModel {
    var selectedRegion : String?
    var fishes = [FishModel]()
    var imageUrl : String?
    weak var delegate : RegionDetailsViewModelDelegate?
    
    func getFishes(){
        
        guard let selectedRegion = selectedRegion else { return }
        print("selectedRegion\(selectedRegion)")
        let firestore = Firestore.firestore()
        let path = firestore.collection("Fishes").whereField("sublocations", arrayContains: selectedRegion)
        
        FirebaseManager.shared.getFishes(queryPath: path) { Result in
            switch Result {
            case .success(let fishes):
                self.fishes = fishes
                self.delegate?.updateFishes()

            case .failure(let failure):
                print("hata")

            }
        }
        
       
       
    }
    func getImage(){
        guard let imageUrl = imageUrl else {
            print("url hatası")
            return  }
        
        NetworkManager.shared.downloadImage(with: imageUrl) { image in
            
            guard let image = image else {
                print("image gelmedi")
                      return}
            self.delegate?.updateImage(image: image)

        }
       
        
       
      
    }
    
    
}
