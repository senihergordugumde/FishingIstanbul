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
    func fishRecognize(fishName : [Species])
    
    
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
    
    func getToken(filename: String, content_type: String, byte_size: Int, checksum: String, image: Data){
        getService.getRecognizeToken { token in
            self.postSerivce.imageToCloud(token: token, filename: filename, content_type: content_type, byte_size: byte_size, checksum: checksum) { result in
                switch result {
                case .success(let model):
                    self.postSerivce.uploadImage(model: model, image: image) { result in
                        switch result {
                        case .success():
                            self.getService.getAIResponse(signedID: model.signedID, token: token) { fishName in
                                print(fishName)
                                switch fishName{
                                    case .success(let fishNames):
                                        self.delegate?.fishRecognize(fishName: fishNames)
                                    case .failure(_):
                                        print("Fish error")
                                    }
                            }
                        case .failure(_):
                            print("recognize fault")
                        }
                    }
                   
                case .failure(_):
                    print("error")
                }
            }
        }
    }
 
    
}
