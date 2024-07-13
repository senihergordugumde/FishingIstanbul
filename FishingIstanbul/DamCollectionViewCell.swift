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
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let pieChart = PieChartView(frame: backView.bounds)
        var entries = [ChartDataEntry]()
        
        entries.append(PieChartDataEntry(value: 60, label: "Dolu"))
        entries.append(PieChartDataEntry(value: 40, label: "Boş"))
        
        let set = PieChartDataSet(entries: entries)
        pieChart.data = PieChartData(dataSet: set)
        set.colors = ChartColorTemplates.pastel()
      
        backView.addSubview(pieChart)
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        
        
        
    }
    
}
