//
//  Alert+Ext.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 4.08.2024.
//

import Foundation
import UIKit
extension UIViewController {
    func makeEAAlert(alertTitle : String, alertMessage : String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            let okButton = UIAlertAction(title: "Tamam", style: .default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
        }

        
    }
}
