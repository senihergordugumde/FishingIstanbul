//
//  ViewController.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 4.07.2024.
//

import UIKit
import MapKit
import WeatherKit
import FirebaseFirestore
class HomepageController: UIViewController, HomepageViewModelDelegate{
 
    func updateWeather(weatherCondition: Weather) {
        DispatchQueue.main.async {
            self.temperature.text = weatherCondition.currentWeather.temperature.formatted()
            
            self.weatherImage.image = UIImage(systemName: weatherCondition.currentWeather.symbolName)
            
            self.windSpeed.text = weatherCondition.currentWeather.wind.speed.formatted()
            
            self.dateLabel.text = weatherCondition.currentWeather.date.formatted()
            
            let direction = weatherCondition.currentWeather.wind.compassDirection.abbreviation
            
            switch direction{
                
            case "NE":
                self.directionLabel.text = "KD"
            case "NW":
                self.directionLabel.text = "KB"
            case "SE":
                self.directionLabel.text = "GD"
            case "SW":
                self.directionLabel.text = "GB"
            case "W":
                self.directionLabel.text = "B"
            case "S":
                self.directionLabel.text = "G"
            case "N":
                self.directionLabel.text = "K"
            case "E":
                self.directionLabel.text = "E"
           
            default:
                break
            }
            
            
        }
    }
    
    func locationForWeather(location: CLLocation) {
        viewModel.getWeather(location: location)
        
    }
    
    func updateFishes() {
        self.fishesCollectionView.reloadData()

    }
    
    func updateDistrict(district: String) {
        districtName.text = district
        self.viewModel.getFishes(location: district)
    }
    
    func reloadData() {
        
        DispatchQueue.main.async {
            self.damCollectionView.reloadData()

        }
    }
    

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fishGoalLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherStatusView: UIView!
    @IBOutlet weak var districtName: UILabel!
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
        viewModel = HomepageViewModel()
        viewModel.delegate = self
        viewModel.getDam()
        viewModel.checkLocationAccesExist()
        navigationItem.title = "Fishing İstanbul"
        navigationController?.navigationBar.prefersLargeTitles = true
        weatherStatusView.layer.cornerRadius = 15
        weatherStatusView.translatesAutoresizingMaskIntoConstraints = false
   
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let fishGoal = UserDefaults.standard.string(forKey: "fishGoal")
        fishGoalLabel.text = "/ \(fishGoal ?? "0") balık"

    }
    private func fishesCollectionViewConf(){
        fishesCollectionView.delegate = self
        fishesCollectionView.dataSource = self
    }
    
    private func progressViewConf(){
        
          progressView.translatesAutoresizingMaskIntoConstraints = false
          
          progressView.layer.cornerRadius = 15
          
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
        damCollectionView.layer.cornerRadius = 15
       
    }
   
    @IBAction func goToMapButton(_ sender: Any) {
        
        performSegue(withIdentifier: "map", sender: nil)
        
    }
    @IBAction func stepperClicked(_ sender: Any) {
        
       
        
    }
    
}



extension HomepageController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == fishesCollectionView{
            
            performSegue(withIdentifier: "FishDetail", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FishDetail"{
            let destination = segue.destination as! FishDetailsController
            
            if let indexPath = sender as? IndexPath{
                
                destination.viewModel.fish =  viewModel.fishes[indexPath.row]

            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == damCollectionView{
            return viewModel.dam.count

        }
        
        if collectionView == fishesCollectionView{
            return viewModel.fishes.count
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
            
            
            cell.set(fish: viewModel.fishes[indexPath.row])
            return cell
        }
        
        
        else{
            let cell = UICollectionViewCell()
            return cell
        }
    }
}

