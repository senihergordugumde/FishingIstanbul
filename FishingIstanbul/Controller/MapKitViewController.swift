//
//  MapKitViewController.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 30.07.2024.
//

import UIKit
import MapKit
class MapKitViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let list = [CLLocationCoordinate2D(latitude: 41.01824, longitude: 28.97255), CLLocationCoordinate2D(latitude: 41.02753, longitude: 28.79630),CLLocationCoordinate2D(latitude: 41.01825, longitude: 28.97255)]
    override func viewDidLoad() {
        super.viewDidLoad()


        
        
        for i in list {
            let annotation =  MKPointAnnotation()

            annotation.coordinate = i
            annotation.title = "Galata Köprüsü"
            mapView.addAnnotation(annotation)
            
        }
     
       
    }
    
 

}
