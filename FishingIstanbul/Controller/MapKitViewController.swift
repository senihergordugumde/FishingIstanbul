//
//  MapKitViewController.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 30.07.2024.
//

import UIKit
import MapKit
import FirebaseFirestore
import GoogleMobileAds

class MapKitViewController: UIViewController, MapKitViewModelDelegate, MKMapViewDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate , GADFullScreenContentDelegate {
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredFishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableview", for: indexPath) as! SearchFishTableViewCell
        cell.set(fish: viewModel.filteredFishes[indexPath.row])
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.isHidden = false
        viewModel.filter(searchText: searchText.capitalized)

    }
    
   
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.isHidden = true
    }
  
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
            
            guard let interstitial = interstitial else {
              return print("Ad wasn't ready.")
            }

            // The UIViewController parameter is an optional.
            interstitial.present(fromRootViewController: nil)
            
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
    private var interstitial: GADInterstitialAd?

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        mapView.delegate = self
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
      
        viewModel.getFishes()

        
        LocationManager.shared.checkLocationAccesExist()
        
        LocationManager.shared.checkLocationAuth { result in
            switch result {
            case .success(let location):
                self.findDistrict(for: location)
            case .failure(let failure):
                print("hata")
            }
        }
        
        Task{
            
            do {
                interstitial = try await GADInterstitialAd.load(
                    withAdUnitID: "ca-app-pub-4730844635676967/8304460142", request: GADRequest())
            } catch {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      print("Ad did fail to present full screen content.")
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad will present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did dismiss full screen content.")
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
