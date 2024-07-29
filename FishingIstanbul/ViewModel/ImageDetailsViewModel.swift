//
//  ImageDetailsViewModel.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 27.07.2024.
//

import Foundation
import UIKit

protocol ImageDetailsViewModelDelegate{
    func deleteSucces()
}

class ImageDetailsViewModel{
    let deleteService = Delete()

    var delegate : ImageDetailsViewModelDelegate?
    var image = UIImage()
    var selecetedImage : ImageModel?
    
    func delete(imageID :UUID){
        deleteService.delete(imageID: imageID) { Result in
            
            switch Result{
                
            case .success(_):
                print("silme başarılı")
                self.delegate?.deleteSucces()
                
            case .failure(_):
                print("silme başarısız")
            }
            
            
            
        }
    }
    
    
    
}
