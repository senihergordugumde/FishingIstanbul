//
//  ImageDetailsViewController.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 27.07.2024.
//

import UIKit

class ImageDetailsViewController: UIViewController, ImageDetailsViewModelDelegate {
    func deleteSucces() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    let viewModel = ImageDetailsViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        
        guard let image = viewModel.selecetedImage else {
            return
        }
        imageView.image = UIImage(data: image.image)
        
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        
        guard let image = viewModel.selecetedImage else { return }
        viewModel.delete(imageID: image.id)
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
