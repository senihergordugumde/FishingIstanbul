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
            damName.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            damName.heightAnchor.constraint(equalToConstant: 24),
            damName.widthAnchor.constraint(equalToConstant: 100)
            
        
        ])
        
       
    }
    
    func set(dam : Document){
        
        self.entries = [PieChartDataEntry(value: dam.fields.rate.doubleValue, label: "Dolu"), PieChartDataEntry(value: (100 - dam.fields.rate.doubleValue), label: "Boş")]
    
      
        let set = PieChartDataSet(entries: entries)
          set.colors = ChartColorTemplates.joyful()
          pieChart.data = PieChartData(dataSet: set)

      
     
      
        damName.text = dam.fields.damName.stringValue
    }
    
}
