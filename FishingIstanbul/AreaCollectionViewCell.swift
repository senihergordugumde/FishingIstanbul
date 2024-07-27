//
//  AreaCollectionViewCell.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 19.07.2024.
//

import UIKit

class AreaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var fishName: UILabel!
    @IBOutlet weak var fishImageView: UIImageView!
    override class func awakeFromNib() {
        
    }
    
    func set(fish : FishModel){
        fishName.text = fish.name
        fishImageView.image = UIImage(named: fish.name)
    }
    
    
}
