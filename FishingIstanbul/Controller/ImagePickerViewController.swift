//
//  ImagePickerViewController.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 25.07.2024.
//

import UIKit
import CoreData
import SwiftHash
import CryptoKit
import CommonCrypto

class ImagePickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, ImagePickerViewModelDelegate {
    
    
    func fishRecognize(fishName: [Species]) {
       
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "Recognize", sender: nil)

        }
    }
    
    
  
    
 
    
    func reloadData() {
        self.collectionView.reloadData()
        
        if viewModel.imageList.isEmpty {
            noImages.isHidden = false
            collectionView.isHidden = true
        }else{
            noImages.isHidden = true
            collectionView.isHidden = false
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Gallery", for: indexPath) as! GalleryCollectionViewCell
        
        cell.set(image: viewModel.imageList[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        performSegue(withIdentifier: "imageDetails", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "imageDetails" {
            let destination = segue.destination as! ImageDetailsViewController
            
            
            if let indexPath = sender as? IndexPath {
                
                destination.viewModel.selecetedImage = viewModel.imageList[indexPath.row]
                                
                
            }
        }
    }
    
    @IBOutlet weak var noImages: UIImageView!
    let imagePicker = UIImagePickerController()
    let viewModel = ImagePickerViewModel()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
      
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getImages()

    }
   
    
    @IBAction func media(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    @IBAction func camera(_ sender: Any) {
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as! UIImage
    
        if let file = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                do {
                    let imageData = try Data(contentsOf: file)
                    let hash = imageData.md5Base64
                    print("MD5 Base64: \(hash)")
                    
                    viewModel.getToken(filename: file.lastPathComponent, content_type: "image/jpeg", byte_size: imageData.count , checksum: hash, image: imageData)
                    
                } catch {
                    print(error)
                }
            }
        viewModel.postImage(image: info[.originalImage] as! UIImage)
        self.dismiss(animated: true)
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
