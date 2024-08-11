//
//  LocationManager.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 6.08.2024.
//

import Foundation
import CoreLocation


extension LocationManager : CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuth { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    
       func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
           print("reddedildi")
       }
    
}

class LocationManager  : NSObject {
    
    
    static let shared = LocationManager()
    
    private override init (){}
    
    private var locationManager : CLLocationManager?
    
    
    //MARK: - Check Location Acces Exist
    func checkLocationAccesExist(){
        DispatchQueue.global().async {
            guard CLLocationManager.locationServicesEnabled() else {return}
        }
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
        
    }
    
    //MARK: - Check Location Auth
   
    func checkLocationAuth(completion : @escaping(Result<CLLocation,Error>)->Void){
        
        guard let locationManager = locationManager else {return}
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            completion(.failure(NSError()))
        case .authorizedWhenInUse, .authorizedAlways:
            if let location = locationManager.location{
                completion(.success(location))
                //findDistrict(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                //self.delegate?.locationForWeather(location: CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            }
            

        @unknown default:
            print("denid")

        }
        
    }
    
 
    
    func findDistrict(latitude : Double, longitude : Double, completion : @escaping(Result<CLPlacemark,Error>) -> Void){
      
       let location = CLLocation(latitude: latitude, longitude: longitude)
       
       let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemark, error in
            if let error = error {
                
                print("geocoder hatası: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemark?.first else {
                print("placemark bulunamadı")
                return
            }
            
            completion(.success(placemark))
            
            if let district = placemark.locality,
               let city = placemark.administrativeArea{
                //self.delegate?.updateDistrict(district: district, city: city)
                print(district)
                print(city)
            
            }
            
        }
    }
}
