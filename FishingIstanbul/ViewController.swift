//
//  ViewController.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 4.07.2024.
//

import UIKit
import MapKit
class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var fishingStatsView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var damCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDamCollectionView()

        
        progressBar.transform = progressBar.transform.scaledBy(x: 1.1, y: 2.2)
        
        
        navigationItem.title = "Fishing İstanbul"

        navigationController?.navigationBar.prefersLargeTitles = true
        
        fishingStatsView.layer.cornerRadius = 25
        fishingStatsView.translatesAutoresizingMaskIntoConstraints  = false
        
    }
    

   
    
    private func configureDamCollectionView(){
        damCollectionView.delegate = self
        damCollectionView.dataSource = self
        damCollectionView.layer.cornerRadius = 25
       
    }
   
    
}



extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = damCollectionView.dequeueReusableCell(withReuseIdentifier: "damCell", for: indexPath) as! DamCollectionViewCell
        
        return cell
    }

    
    
    
    
}

