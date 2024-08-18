//
//  RecognizeViewModel.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 2.08.2024.
//

import Foundation


protocol RecognizeViewModelDelegate :AnyObject{
    func imageSelected(result : FishResponse, image : Data)
    func startIndicator()
    func stopIndicator()
    func AIError(title : String, message : String)
}

class RecognizeViewModel {
    
    weak var delegate : RecognizeViewModelDelegate?
        
      func getTokens(completion : @escaping(Token) -> Void){
          self.delegate?.startIndicator()
          NetworkManager.shared.getToken { result in
              switch result {
                  
              case .success(let token):
                  completion(token)
                  
              case .failure(let error):
                  print("token alınamadı")
                  self.delegate?.stopIndicator()
                
              }
          }
      }
      
      func uploadImages(filename :String, content_type : String, byte_size : Int, checksum : String, completion : @escaping(Result<AIResponseModel,Error>) -> Void) {
          
          getTokens { Token in
              NetworkManager.shared.uploadPhoto(token: Token.access_token, filename: filename, content_type: content_type, byte_size: byte_size, checksum: checksum) { result in
                  switch result {
                      
                  case .success(let AIResponse):
                      completion(.success(AIResponse))
                  case .failure(let error):
                      print("AI Servisi Çevrim dışı : \(error.localizedDescription)")
                      self.delegate?.AIError(title: "AI Servisi Çevrim dışı :", message: error.localizedDescription)
                      self.delegate?.stopIndicator()
                      completion(.failure(NSError()))


                  }
              }
          }
      
      }
      
      
      func putPhoto(filename :String, content_type : String, byte_size : Int, checksum : String, image : Data, completion : @escaping(AIResponseModel) -> Void){
          uploadImages(filename: filename, content_type: content_type, byte_size: byte_size, checksum: checksum) { result in
              switch result {
              case .success(let model):
                  NetworkManager.shared.putPhoto(model: model, image: image) { result in
                                    switch result {
                                        
                                    case .success(_):
                                        print("başarılı")
                                        completion(model)
                                    case .failure(let error):
                                        print("Fotoğraf Yükleme Hatası : \(error.localizedDescription)")
                                        self.delegate?.AIError(title: "Fotoğraf Yükleme Hatası :", message: "Seçtiğiniz resmin boyutu çok büyük. Yeniden denemek sorunu çözebilir.")
                                        self.delegate?.stopIndicator()

                                    }
                                }
              case .failure(let failure):
                  print("hata")
              }
          }
      }
      
    func fishRecognition(filename :String, content_type : String, byte_size : Int, checksum : String, image : Data){
          
          getTokens { Token in
              self.putPhoto(filename :filename, content_type : content_type, byte_size : byte_size, checksum : checksum, image : image) { model in
                  NetworkManager.shared.getRecognition(model: model , token: Token.access_token) { result in
                      switch result {
                      case .success(let result):
                          
                          if result.results.isEmpty{
                              self.delegate?.AIError(title: "Tanımlama Hatası", message: "Balık Türü Tanımlanamadı")
                          }
                          else{
                              self.delegate?.imageSelected(result: result, image: image)
                          }
                          self.delegate?.stopIndicator()
                         
                      case .failure(let error):
                          print("Tanıma hatası : \(error.localizedDescription)")
                          self.delegate?.AIError(title: "Tanıma hatası :", message: error.localizedDescription)
                          self.delegate?.stopIndicator()

                      }
                  }
              }
            
          }
         
      }
}
