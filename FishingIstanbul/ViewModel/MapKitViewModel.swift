//
//  MapKitViewModel.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 6.08.2024.
//

import Foundation
import FirebaseFirestore
import MapKit
protocol MapKitViewModelDelegate : AnyObject {
    func addPinToMap(title : String, coordinate : CLLocationCoordinate2D, imageUrl : String)
    func reloadData()
}

class MapKitViewModel {
    let firestore = Firestore.firestore()

    weak var delegate : MapKitViewModelDelegate?
    var fishes = [FishModel]()
    var filteredFishes = [FishModel]()
    var locations = [String]()
    var pins = [MapLocationsModel]()
    
    
    func filter(searchText : String){
        self.filteredFishes = self.fishes.filter({$0.name.contains(searchText)})
        self.locations =  self.filteredFishes.flatMap({$0.sublocations})
        print(filteredFishes)
        self.delegate?.reloadData()
    }
    
    func getFishes(){
        
        let path = firestore.collection("Fishes")
        
        FirebaseManager.shared.getFishes(queryPath: path) { result in
            switch result {
            case .success(let fishes):
                self.fishes = fishes
            case .failure(let failure):
                print("balıklar alınamadı")
            }
        }
    }
    
    func getMapLocations(city : String){
        let path = firestore.collection("Cities").document("Istanbul").collection("Locations")
        FirebaseManager.shared.getMapLocations(queryPath: path) { Result in
            switch Result {
            case .success(let pins):
                for pin in pins {
                    self.delegate?.addPinToMap(title: pin.name, coordinate: CLLocationCoordinate2D(latitude: pin.location.latitude, longitude: pin.location.longitude), imageUrl: pin.image)
                    

                }
                self.pins = pins

            case .failure(let failure):
                print("pin error")
            }
        }
    }
 
    
}


