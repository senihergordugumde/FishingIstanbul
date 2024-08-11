//
//  MapKitViewController.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 30.07.2024.
//

import UIKit
import MapKit
import FirebaseFirestore
class MapKitViewController: UIViewController, MapKitViewModelDelegate, MKMapViewDelegate {
    
  
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation as? CustomAnnotationPoint else { return }
        
        
        
        self.performSegue(withIdentifier: "Region", sender: annotation)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Region" {
            
            let destination = segue.destination as! RegionDetailsViewController
            
            if let annotation = sender as? CustomAnnotationPoint {
                print(annotation)
                destination.viewModel.selectedRegion = annotation.title
                destination.viewModel.imageUrl = annotation.imageUrl
                
            }
            
        }
    }
    
    
    func addPinToMap(title: String, coordinate: CLLocationCoordinate2D, imageUrl : String) {
        let annotation = CustomAnnotationPoint()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.imageUrl = imageUrl
        mapView.addAnnotation(annotation)
    
    }
    

    @IBOutlet weak var mapView: MKMapView!
    
    let viewModel = MapKitViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        mapView.delegate = self
        LocationManager.shared.checkLocationAccesExist()
        
        LocationManager.shared.checkLocationAuth { result in
            switch result {
            case .success(let location):
                self.findDistrict(for: location)
            case .failure(let failure):
                print("hata")
            }
        }
        
        
    }
    
 
    private func findDistrict(for location: CLLocation) {
        LocationManager.shared.findDistrict(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { result in
            switch result {
            case .success(let placemark):
                if let district = placemark.locality, let city = placemark.administrativeArea {
                    print("İlçe: \(district), Şehir: \(city)")
                    self.viewModel.getMapLocations(city: city)
                }
            case .failure(let error):
                print("İlçe bulunamadı: \(error.localizedDescription)")
            }
        }
    }
}
