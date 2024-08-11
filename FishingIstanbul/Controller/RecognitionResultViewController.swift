//
//  RecognitionResultViewController.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 4.08.2024.
//

import UIKit

class RecognitionResultViewController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    
    let turkishNames : [String : String] = ["cyprinus carpio" : "Sazan"]
    
    @IBOutlet weak var scinefName: UILabel!
    @IBOutlet weak var fishName: UILabel!
    
    @IBOutlet weak var familyName: UILabel!
    @IBOutlet weak var selectedFishImage: UIImageView!
    var selectedFish : Data?
    var model : FishResponse?
    let viewModel = RecognitionResultViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        
        backView.layer.cornerRadius = 25
        
        
        guard let model = model else {
            return
        }
        
        
        guard let fishTitle = model.results.first?.species.first?.name  else { return }
        
        guard let familyTitle = model.results.first?.species.first?.fishanglerData.family else { return }
        
        fishName.text = viewModel.fishDictionary[fishTitle] //model.results.first?.species.first?.fishanglerData.commonNames.first
        
        familyName.text = viewModel.fishFamilies[familyTitle]
        scinefName.text = fishTitle
        
        selectedFishImage.image = UIImage(data: selectedFish!)
        print(model.results.first?.species.first?.fishanglerData.family)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
