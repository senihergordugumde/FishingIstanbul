//
//  Date+Ext.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 9.08.2024.
//

import Foundation

extension Date {
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    
}
