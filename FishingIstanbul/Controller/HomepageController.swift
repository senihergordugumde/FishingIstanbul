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
import GoogleMobileAds

class HomepageController: UIViewController, HomepageViewModelDelegate, GADFullScreenContentDelegate{
    

    
    func showAlert() {
        let alert = UIAlertController(title: "Konum Kapalı", message: "Doğru veriler için konum izninize ihtiyaç duyuyoruz.", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Ayarlara Git", style: .default, handler: { action in
                switch action.style{
        
                case .default:
                    UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")

                @unknown default:
                    print("def")
                }
            }))
    }
    
    
 
    func updateWeather(weatherCondition: Weather) {
        DispatchQueue.main.async {
            
           
            
            let fishingProbability = FishingProbability(temperature: weatherCondition.currentWeather.temperature.value, wind_speed: weatherCondition.currentWeather.wind.speed.value, pressure: weatherCondition.currentWeather.pressure.value, uv_index: Double(weatherCondition.currentWeather.uvIndex.value), precipitation_intensity: weatherCondition.currentWeather.precipitationIntensity.value, visibility: weatherCondition.currentWeather.visibility.value, humidity: weatherCondition.currentWeather.humidity, hour: weatherCondition.currentWeather.date.hour)
      
            
            let fishProbabilityCounter = fishingProbability.calculateFishingProbability(params: fishingProbability).rounded()
            
            self.fishProbabilityCount.text = "Bugün Balık Tutma İhtimaliniz %\(fishProbabilityCounter)"
            
            self.progressBar.progress = Float(fishProbabilityCounter / 100)
        
            
            self.temperature.text = weatherCondition.currentWeather.temperature.formatted()
            
            self.weatherImage.image = UIImage(systemName: weatherCondition.currentWeather.symbolName)
            
            self.windSpeed.text = weatherCondition.currentWeather.wind.speed.formatted()
            
            self.dateLabel.text = weatherCondition.currentWeather.date.formatted()
            
            let direction = weatherCondition.currentWeather.wind.compassDirection.abbreviation
            
            print(direction)
            switch direction{
                
            case "NE", "NNE":
                self.directionLabel.text = "KD"
            case "NW", "NNW":
                self.directionLabel.text = "KB"
            case "SE", "SSE":
                self.directionLabel.text = "GD"
            case "SW", "WSW":
                self.directionLabel.text = "GB"
            case "W", "WNW":
                self.directionLabel.text = "B"
            case "S", "SSW":
                self.directionLabel.text = "G"
            case "N", "NNW":
                self.directionLabel.text = "K"
            case "E","ESE":
                self.directionLabel.text = "E"
           
            default:
                break
            }
            
            
        }
    }
    
    func stepperUpdate(value: Double) {
        currentFish.text = value.formatted()
        print(value)
    }
    
    func locationForWeather(location: CLLocation) {
        viewModel.getWeather(location: location)
        
    }
    
    func updateFishes() {
        self.fishesCollectionView.reloadData()

    }
    
    func updateDistrict(district: String, city : String) {
        districtName.text = district
        cityName.text = city
      
        self.viewModel.getFishes(district: district.turnToEnglish())
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
    
    @IBOutlet weak var fishProbabilityCount: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var fishError: UIView!
    @IBOutlet weak var fishesCollectionView: UICollectionView!
    var getService: GetService!
       var viewModel: HomepageViewModel!
    private var interstitial: GADInterstitialAd?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDamCollectionView()
        fishesCollectionViewConf() // değiştir ismi
        progressViewConf()
        viewModel = HomepageViewModel()
        viewModel.delegate = self
        viewModel.getDam()
        viewModel.checkLocationAccesExist()
        confStepper()
        navigationItem.title = "Fishing İstanbul"
        navigationController?.navigationBar.prefersLargeTitles = true
        weatherStatusView.layer.cornerRadius = 15
        weatherStatusView.translatesAutoresizingMaskIntoConstraints = false
       
        Task {
             do {
                 interstitial = try await GADInterstitialAd.load(
                   withAdUnitID: "ca-app-pub-4730844635676967/9466053486", request: GADRequest())
                 interstitial?.fullScreenContentDelegate = self
               } catch {
                 print("Failed to load interstitial ad with error: \(error.localizedDescription)")
               }
         }
        
        guard let interstitial = interstitial else {
          return print("Ad wasn't ready.")
        }

        // The UIViewController parameter is an optional.
        interstitial.present(fromRootViewController: nil)
        
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
    func confStepper(){
        stepper.value = UserDefaults.standard.double(forKey: "stepperValue")
        currentFish.text = stepper.value.formatted()
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
        
        viewModel.stepperClicked(stepper: stepper)
       
        
    }
    
 
    
}



extension HomepageController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == fishesCollectionView{
            
            //performSegue(withIdentifier: "FishDetail", sender: indexPath)
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
            
            if viewModel.fishes.count <= 0 {
                fishError.isHidden = false
                collectionView.isHidden = true
            } else {
                fishError.isHidden = true
                collectionView.isHidden = false
            }
            
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

