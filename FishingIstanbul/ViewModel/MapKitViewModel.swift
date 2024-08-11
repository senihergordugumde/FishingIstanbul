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
}

class MapKitViewModel {

    weak var delegate : MapKitViewModelDelegate?
    
    var pins = [MapLocationsModel]()
    
    func getMapLocations(city : String){
        let firestore = Firestore.firestore()
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


