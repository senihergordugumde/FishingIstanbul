//
//  DamCollectionViewCell.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 4.07.2024.
//

import UIKit
import DGCharts
class DamCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var backView: UIView!
    var pieChart : PieChartView!
    var entries = [PieChartDataEntry]()
    let damName = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()

          pieChart = PieChartView(frame: backView.bounds)
          
          backView.addSubview(pieChart)
          backView.addSubview(damName)
          pieChart.translatesAutoresizingMaskIntoConstraints = false
        
        damName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            damName.topAnchor.constraint(equalTo: backView.topAnchor),
            damName.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 15),
            damName.heightAnchor.constraint(equalToConstant: 24),
            damName.widthAnchor.constraint(equalToConstant: 100)
            
        
        ])
        
       
    }
    
    func set(dam : Document){
        
        self.entries = [PieChartDataEntry(value: dam.fields.rate.doubleValue, label: "Dolu"), PieChartDataEntry(value: (100 - dam.fields.rate.doubleValue), label: "Boş")]
    
      
        let set = PieChartDataSet(entries: entries)
        set.colors = [NSUIColor(red: 49/255.0, green: 211/255.0, blue: 248/255.0, alpha: 1.0),
                      NSUIColor(red: 255/255.0, green: 105/255.0, blue: 105/255.0, alpha: 1.0)
]
     
          pieChart.data = PieChartData(dataSet: set)

      
     
      
        damName.text = dam.fields.damName.stringValue
    }
    
}
