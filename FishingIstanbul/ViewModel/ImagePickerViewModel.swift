//
//  ImagePickerViewModel.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 27.07.2024.
//

import Foundation
import UIKit


protocol ImagePickerViewModelDelegate : AnyObject {
    
    func reloadData()
    
    
}
class ImagePickerViewModel {
    
    weak var delegate : ImagePickerViewModelDelegate?
    
    let getService = Get()
    let postSerivce = Post()
    var imageList = [ImageModel]()
    
    
    func postImage(image : UIImage){
        postSerivce.postImage(image: image) { Result in
            switch Result{
            case .success(_):
                self.imageList.removeAll()
                self.getImages()
                self.delegate?.reloadData()
            case .failure(_):
                print("post error")
            }
        }
    }
    
    func getImages(){
        getService.fetchCoreData { Result in
            switch Result {
            case .success(let images):

                self.imageList = images
                self.delegate?.reloadData()
            case .failure(_):
                print("viewmodel error")
            }
            
        }
    }
    
 
    
}
