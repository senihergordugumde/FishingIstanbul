//
//  RecognizeViewController.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 2.08.2024.
//

import UIKit

class RecognizeViewController: UIViewController {

    @IBOutlet weak var fishName: UILabel!
    let viewModel = RecognizeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(viewModel.name)
        fishName.text = viewModel.name
        
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
