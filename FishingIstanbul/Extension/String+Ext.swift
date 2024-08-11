//
//  String+Ext.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 28.07.2024.
//

import Foundation

extension String{
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
    

    func turnToEnglish() -> String{
        let turkishChars = ["ı", "ğ", "İ", "Ğ", "ç", "Ç", "ş", "Ş", "ö", "Ö", "ü", "Ü"]
        let englishChars = ["i", "g", "I", "G", "c", "C", "s", "S","o", "O", "u", "U"]
        
        let charDict : [Character : Character] = [
            "ı" : "i",
            "ğ" : "g",
            "İ" : "I",
            "Ğ" : "G",
            "ç" : "c",
            "Ç" : "C",
            "ş" : "s",
            "Ş" : "S",
            "ö" : "o",
            "Ö" : "O",
            "ü" : "u",
            "Ü" : "U"
        ]
    
        return self.map { charDict[$0] ?? $0}.reduce("") { $0 + String($1)}
    
        
    }
    


    
}
