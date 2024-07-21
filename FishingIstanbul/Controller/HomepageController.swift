//
//  ViewController.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 4.07.2024.
//

import UIKit
import MapKit
class HomepageController: UIViewController, HomepageViewModelDelegate {
    func updateDistrict(district: String) {
        districtName.text = district
    }
    
    func reloadData() {
        
        DispatchQueue.main.async {
            self.damCollectionView.reloadData()

        }
    }
    

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var districtName: UILabel!
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var currentFish: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var damCollectionView: UICollectionView!
    
    @IBOutlet weak var fishesCollectionView: UICollectionView!
    var getService: GetService!
       var viewModel: HomepageViewModel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDamCollectionView()
        fishesCollectionViewConf() // değiştir ismi
        progressViewConf()
        
        getService = Get()
        viewModel = HomepageViewModel(getService: getService)
        viewModel.delegate = self
        viewModel.getDam()
        viewModel.checkLocationAccesExist()
        navigationItem.title = "Fishing İstanbul"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        cityImage.translatesAutoresizingMaskIntoConstraints = false
        cityImage.layer.cornerRadius = 20
    
       
      
        
    }
    
    private func fishesCollectionViewConf(){
        fishesCollectionView.delegate = self
        fishesCollectionView.dataSource = self
    }
    
    private func progressViewConf(){
        
          progressView.translatesAutoresizingMaskIntoConstraints = false
          
          progressView.layer.cornerRadius = 25
          
          progressView.isUserInteractionEnabled = true
          
          let gestureRec = UITapGestureRecognizer(target: self, action: #selector(progressViewClicked))
          
          progressView.addGestureRecognizer(gestureRec)
    }
    
    @objc func progressViewClicked(){
        self.performSegue(withIdentifier: "statsChanger", sender: nil)
    }
   
    
    private func configureDamCollectionView(){
        damCollectionView.delegate = self
        damCollectionView.dataSource = self
        damCollectionView.layer.cornerRadius = 25
       
    }
   
    @IBAction func goToMapButton(_ sender: Any) {
        
        performSegue(withIdentifier: "map", sender: nil)
        
    }
    @IBAction func stepperClicked(_ sender: Any) {
        
        currentFish.text = String(Int(stepper.value))
        
    }
    
}



extension HomepageController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == fishesCollectionView {
            
            performSegue(withIdentifier: "FishDetail", sender: nil)
            
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == damCollectionView{
            return viewModel.dam.count

        }
        
        if collectionView == fishesCollectionView{
            return 5
        }
        
        else{
            return 0
        }
    }
    
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == damCollectionView{
            let cell = damCollectionView.dequeueReusableCell(withReuseIdentifier: "damCell", for: indexPath) as! DamCollectionViewCell
            
            
            cell.set(dam: viewModel.dam[indexPath.row])
            
            
            return cell
        }
        
        if collectionView == fishesCollectionView{
            let cell = fishesCollectionView.dequeueReusableCell(withReuseIdentifier: "Fishes", for: indexPath) as! AreaCollectionViewCell
            
            return cell
        }
        
        
        else{
            let cell = UICollectionViewCell()
            return cell
        }
    }

    
    
    
    
}

