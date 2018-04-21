//
//  StatisticsController.swift
//  FitnessTrackerApplication
//
//  Created by Xcode User on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.
//

import UIKit
import Charts

class StatisticsController: UIViewController, ChartViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var chartView: LineChartView!
    @IBOutlet var metricSeg: UISegmentedControl!
    @IBOutlet var pickerView: UIPickerView!
    
    var monthDefault = 0
    var woDefault = 0
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    
    var monthWO = [NSInteger]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        
        if(component == 1){
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "Montserrat", size: 6)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        pickerLabel?.text = months[row]
        
        return pickerLabel!;
        }
            
        else{
            var pickerLabel = view as? UILabel;
            
            if (pickerLabel == nil)
            {
                pickerLabel = UILabel()
                
                pickerLabel?.font = UIFont(name: "Montserrat", size: 6)
                pickerLabel?.textAlignment = NSTextAlignment.center
            }
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            var wi: WorkoutInfo = mainDelegate.workoutInfo.object(at: row) as! WorkoutInfo
            
            
            pickerLabel?.text = wi.name
            
            return pickerLabel!
            
        }
    return (view as! UILabel)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(component == 0){
         let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            var wi: WorkoutInfo = mainDelegate.workoutInfo.object(at: row) as! WorkoutInfo
            
            return wi.name
            
        }
        if(component == 1){
            
            return months[row]
            
        }
       
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if(component == 0){
            
            return mainDelegate.workoutInfo.count
        }
        if(component == 1){
            
             return months.count
            
        }
        
       return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0){
            
            self.generateLineData(metric: 0, month: monthDefault, workoutN: row)
        }
        if(component == 1){
            
            self.generateLineData(metric: 0, month: row, workoutN: woDefault)
        }
        
    }
    
    
    @IBAction func metricChanged(sender : UISegmentedControl){
        
        var metric : NSInteger = sender.selectedSegmentIndex
        generateLineData(metric: metric, month: monthDefault, workoutN: woDefault)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.delegate = self
        chartView.chartDescription?.enabled = false
        
        let leftAxis = chartView.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.labelTextColor = NSUIColor.black
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.axisMinimum = 0
        xAxis.granularity = 1
        xAxis.labelTextColor = NSUIColor.black
        
        chartView.rightAxis.enabled = false
        
        chartView.backgroundColor = NSUIColor(red: 35/255.0, green: 43/255.0, blue: 53/255.0, alpha: 0.2)
        chartView.setVisibleXRangeMaximum(5)
        self.generateLineData(metric: 0, month: monthDefault, workoutN: woDefault)
        
    }
    
    func generateLineData(metric : NSInteger, month: NSInteger, workoutN: NSInteger) {
         monthDefault = month
         woDefault = workoutN
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        var w : WorkoutTracking = .init()
        var entries = [ChartDataEntry]()
        var wi : WorkoutInfo = .init()
        var metricType : String = ""
        
      
                for (n, _) in mainDelegate.workouts.enumerated() {
                    
                    w = mainDelegate.workouts.object(at: n) as! WorkoutTracking
                    
                    if(workoutN == Int(w.wID)){
                        
                        switch metric {
                            
                        case 0:
                            metricType = w.reps
                        case 1:
                            metricType = w.sets
                        case 2:
                            metricType = w.weight
                        case 3:
                            metricType = w.duration
                        default:
                            metricType = ""
                        }
                        
                        let dayNumber = Int(w.date.suffix(2))
                        if(dayNumber == nil){
                            entries.append(ChartDataEntry(x: 0.0, y: 0.0))
                        }
                        if(metricType == ""){
                            entries.append(ChartDataEntry(x: 0.0, y: 0.0))
                        }
                        
                        var indexStartOfText = w.date.index(w.date.startIndex, offsetBy: 5)
                        var indexEndOfText = w.date.index(w.date.endIndex, offsetBy: -3)
                        
                        var substringDate = Int(w.date[indexStartOfText..<indexEndOfText])
                        
                        print("Substring date")
                        print(substringDate!)
                        print("Month")
                        print(month)
                        if(month == substringDate!){
                        
                        entries.append(ChartDataEntry(x: Double((dayNumber)!), y: (Double(metricType))!))
                        
                    }
                }
                
                let set = LineChartDataSet(values: entries, label: "Metric Values")
                
                set.setColor(NSUIColor.red)
                set.lineWidth = 5
                set.setCircleColor(NSUIColor.blue)
                set.circleHoleColor = UIColor(red: 35/255, green: 43/255, blue: 53/255, alpha: 1)
                set.circleRadius = 5
                set.circleHoleRadius = 2
                set.fillColor = (NSUIColor.black)
                set.mode = .linear
                set.drawValuesEnabled = true
                set.valueFont = .systemFont(ofSize: 10)
                set.valueTextColor = UIColor(red: 35/255, green: 43/255, blue: 53/255, alpha: 1)
                
                set.axisDependency = .left
                
                let data = LineChartData(dataSet: set)
                
                chartView.data = data
                chartView.chartDescription?.text = "1 Month"
                chartView.notifyDataSetChanged()
            }
            
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

