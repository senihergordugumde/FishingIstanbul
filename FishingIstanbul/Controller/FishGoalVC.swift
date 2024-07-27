//
//  fishGoalVC.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 17.07.2024.
//

import UIKit

class FishGoalVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var fishGoal = [String]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fishGoal.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fishGoal[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        
        UserDefaults.standard.set(fishGoal[row], forKey: "fishGoal")
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        
        for i in 0...100{
            fishGoal.append(i.formatted())
        }

    }
    

  

}
