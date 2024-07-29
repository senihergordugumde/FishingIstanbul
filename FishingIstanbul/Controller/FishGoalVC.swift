//
//  fishGoalVC.swift
//  FishingIstanbul
//
//  Created by Emir AKSU on 17.07.2024.
//

import UIKit
import DGCharts
class FishGoalVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var statsBackView: UIView!
    var fishGoal = [String]()
    var chartDatas = [ChartDataEntry]()
    let lineChart = LineChartView()
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
        UserDefaults.standard.set(Date().addingTimeInterval(7*24*60*60), forKey: "goalTimer")
        
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        

        if var dates = UserDefaults.standard.value(forKey: "dates") as? [String] {
            
            if let fishCountList = UserDefaults.standard.value(forKey: "fishCountList") as? [Double] {
                
                for (index, count) in fishCountList.enumerated(){
                    
                    print(index,count)
                    let chartData = ChartDataEntry(x: Double(index), y: count)
                    self.chartDatas.append(chartData)
  
                }
  
            }
            
            let set = LineChartDataSet(entries: chartDatas)
            let data = LineChartData(dataSet: set)

            lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
            lineChart.data = data
            
            set.mode = .horizontalBezier
            set.drawCircleHoleEnabled = false
            set.circleRadius = 5
            set.lineWidth = 5.0
            set.drawFilledEnabled = true
            set.fillColor = NSUIColor.secondaryLabel
           
            lineChart.data = data

        }
     
        lineChart.animate(xAxisDuration: CATransaction.animationDuration(),  yAxisDuration:  CATransaction.animationDuration(), easingOption: .linear)
        lineChart.drawGridBackgroundEnabled = false
        lineChart.xAxis.labelPosition = .bottom // Etiketler altta görünsün
        lineChart.xAxis.labelRotationAngle = -25
        lineChart.xAxis.granularity = 1.0
        lineChart.isUserInteractionEnabled = false
        
        statsBackView.addSubview(lineChart)
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        
            lineChart.topAnchor.constraint(equalTo: statsBackView.topAnchor),
            lineChart.leadingAnchor.constraint(equalTo: statsBackView.leadingAnchor),
            lineChart.trailingAnchor.constraint(equalTo: statsBackView.trailingAnchor),
            lineChart.bottomAnchor.constraint(equalTo: statsBackView.bottomAnchor)
        
        ])

        pickerView.delegate = self
        pickerView.dataSource = self
        
        for i in 0...100{
            fishGoal.append(i.formatted())
        }

    }
    

  

}
