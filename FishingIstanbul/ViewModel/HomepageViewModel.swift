//
//  HomepageViewModel.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 18.07.2024.
//

import Foundation
import CoreLocation
import WeatherKit
import UIKit
protocol HomepageViewModelDelegate : AnyObject{
    func reloadData()
    func updateDistrict(district: String)
    func updateFishes()
    func locationForWeather(location: CLLocation)
    func updateWeather(weatherCondition : Weather)
    func stepperUpdate(value : Double)
    
 
  
}

class HomepageViewModel: NSObject ,CLLocationManagerDelegate{
    weak var delegate : HomepageViewModelDelegate?
    
    private let getService = Get()
    var locationManager : CLLocationManager?
    var dam = [Document]()
    var fishes = [FishModel]()
    var fishCounter = UserDefaults.standard.string(forKey: "fishCounter") ?? "0"
    
    
    func stepperClicked(stepper : UIStepper){
        UserDefaults.standard.set(stepper.value, forKey: "stepperValue")
        self.delegate?.stepperUpdate(value: stepper.value)
        
    }
    
    
    func getWeather(location : CLLocation){
        getService.getWeather(location: location) { Result in
            switch Result{
   
            case .success(let weather):
                self.delegate?.updateWeather(weatherCondition : weather)
            case .failure(_):
                print("weather hata")
            }
        }
    }
    
    
    func getFishes(location : String){
        getService.getFishes(location: location) { Result in
            switch Result{
            case .success(let fishes):
                self.fishes = fishes
                self.delegate?.updateFishes()
            case .failure(_):
                print("hata")
            }
        }
    }
    
    
    func getDam(){

        getService.getDams { Result in
            switch Result{
                
            case .success(let dams):
                print(dams.documents.count)
                self.dam = dams.documents
                self.delegate?.reloadData()
            case .failure(_):
                print("barajar gelmedi")
            }
        }
        
    }
    
    
    func checkLocationAccesExist(){
        DispatchQueue.global().async {
            guard CLLocationManager.locationServicesEnabled() else {return}
        }
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
    }
    
   
    func checkLocationAuth(){
        
        guard let locationManager = locationManager else {return}
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
           
        case .restricted:
            print("restricted")
        case .denied:
            locationManager.requestWhenInUseAuthorization()
        
        case .authorizedWhenInUse, .authorizedAlways:
            if let location = locationManager.location{
                findDistrict(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                self.delegate?.locationForWeather(location: CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            }
            

        @unknown default:
            print("denid")

        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuth()
    }
    
    func findDistrict(latitude : Double, longitude : Double){
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
            
            if let district = placemark.locality{
                self.delegate?.updateDistrict(district: district)
            
            }
            
        }
    }
    
}
