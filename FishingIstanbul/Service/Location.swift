//
//  Location.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 19.07.2024.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate : AnyObject {
    
    func didUpdateLocation()
    func didErrorLocation()
}



class Location : NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    weak var delegate : LocationServiceDelegate!
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            
            print(location.coordinate.latitude)
            self.delegate.didUpdateLocation()
            locationManager.stopUpdatingLocation()
        }
        
        else{
            print("hta")
            self.delegate.didErrorLocation()
            locationManager.stopUpdatingLocation()

        }
    }
        
   

    
    
    
}
