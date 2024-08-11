//
//  GalleryCollectionViewCell.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 26.07.2024.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override class func awakeFromNib() {
    
    }
    
    
    func set(image : ImageModel){
        self.imageView.image = UIImage(data: image.image)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
    }
    
    
}
