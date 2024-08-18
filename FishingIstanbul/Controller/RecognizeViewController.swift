//
//  RecognizeViewController.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 2.08.2024.
//

import UIKit
import GoogleMobileAds

class RecognizeViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, RecognizeViewModelDelegate,GADFullScreenContentDelegate {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var interstitial: GADInterstitialAd?

    func startIndicator() {
        DispatchQueue.main.async{
            self.activityIndicator.startAnimating()

        }
        
    }
    
    func stopIndicator() {
        DispatchQueue.main.async{
            self.activityIndicator.stopAnimating()

        }
    }
    
    
    func AIError(title: String, message: String) {
        self.makeEAAlert(alertTitle: title, alertMessage: message)
    }
    
    
    func imageSelected(result: FishResponse, image : Data) {
        
        let dataList = [result,image] as [Any]
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "recognition", sender: dataList)

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "recognition" {
            if let destination = segue.destination as? RecognitionResultViewController {
                if let result = sender as? [Any] {
                    destination.model = result.first as? FishResponse
                    destination.selectedFish = result.last as? Data
                }
            }
            
            
             
             guard let interstitial = interstitial else {
               return print("Ad wasn't ready.")
             }

             // The UIViewController parameter is an optional.
             interstitial.present(fromRootViewController: nil)
        }
      
    }

  
    @IBOutlet weak var fishName: UILabel!
    let viewModel = RecognizeViewModel()
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        Task{
            
            
            do {
                interstitial = try await GADInterstitialAd.load(
                    withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: GADRequest())
                interstitial?.fullScreenContentDelegate = self
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
    
 
    @IBAction func camera(_ sender: Any) {
        
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
    
    @IBAction func photoLibrary(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        
      
        if let file = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                do {
                    let imageData = try Data(contentsOf: file)
                    let image = UIImage(data: imageData)
                    
                 
                    print("MD5 Base64: \(hash)")
                
                    let compImage = image?.jpegData(compressionQuality: 0.4)
                    let hash = compImage!.md5()
                    viewModel.fishRecognition(filename: file.lastPathComponent, content_type: "image/jpeg", byte_size: compImage!.count, checksum: hash, image: compImage!)
                } catch {
                    print(error)
                }
            }
        self.dismiss(animated: true)
    }
   
}
