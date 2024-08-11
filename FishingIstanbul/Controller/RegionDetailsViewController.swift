//
//  RegionDetailsViewController.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 7.08.2024.
//

import UIKit
import MapKit
class RegionDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, RegionDetailsViewModelDelegate {
    func updateImage(image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image

        }
    }
    
    func updateFishes() {
        self.collectionView.reloadData()
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectedRegionName: UILabel!
    let viewModel = RegionDetailsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.delegate = self
        viewModel.getFishes()
        viewModel.getImage()
        navigationItem.title = viewModel.selectedRegion
        navigationController?.navigationBar.prefersLargeTitles = true
        selectedRegionName.text = viewModel.selectedRegion
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.fishes.count
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Fishes", for: indexPath) as! AreaCollectionViewCell
        
        
        cell.set(fish: viewModel.fishes[indexPath.row])
        return cell
    }
    
    
    
}
