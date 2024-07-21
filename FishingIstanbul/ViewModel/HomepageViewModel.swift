//
//  HomepageViewModel.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 18.07.2024.
//

import Foundation
import CoreLocation

protocol HomepageViewModelDelegate : AnyObject{
    func reloadData()
    func updateDistrict(district: String)
}

class HomepageViewModel: NSObject ,CLLocationManagerDelegate{
    weak var delegate : HomepageViewModelDelegate?
    
    private let getService : GetService
    var locationManager : CLLocationManager?
    var dam = [Document]()
    var district = String()
    
    init(getService: GetService) {
     
        self.getService = getService
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
            
            if CLLocationManager.locationServicesEnabled(){
                self.locationManager = CLLocationManager()
                self.locationManager!.delegate = self
                self.checkLocationAuth()


            }
            else{
                    print("locations off")
            }
        }
    }
    
   
    func checkLocationAuth(){
        guard let locationManager = locationManager else { 
            return }
        print("yes")

        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
           
        case .restricted:
            print("restricted")
        case .denied:
            print("denid")
                  
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            if let location = locationManager.location{
                findDistrict(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
            

        @unknown default:
            print("denid")

        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let locationManager = locationManager else {
            return }
        if let location = locationManager.location{
            findDistrict(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
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
