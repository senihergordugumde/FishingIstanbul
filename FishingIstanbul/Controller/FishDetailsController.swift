//
//  FishDetailsController.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 22.07.2024.
//

import UIKit

class FishDetailsController: UIViewController{
   
    @IBOutlet weak var fishName: UILabel!
    @IBOutlet weak var fishName2: UILabel!
    @IBOutlet weak var mevsimLabel: UILabel!
    
    @IBOutlet weak var fishImage: UIImageView!
    @IBOutlet weak var locationsLabel: UILabel!
    let liste = ["Mevsim", "Konumalar"]
    var viewModel = FishDetailsViewModel()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fishName.text = viewModel.fish?.name
        DispatchQueue.main.async {
            self.fishImage.image = UIImage(named: self.viewModel.fish!.name)
        }
    }
    

    
    

}
