//
//  SearchFishTableViewCell.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 12.08.2024.
//

import UIKit

class SearchFishTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var fishName: UILabel!
    
    @IBOutlet weak var fishImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func set(fish : FishModel){
        self.fishImage.image = UIImage(named: fish.name)
        self.fishName.text = fish.name
        self.locationLabel.text = fish.locations.formatted()
    }

}
