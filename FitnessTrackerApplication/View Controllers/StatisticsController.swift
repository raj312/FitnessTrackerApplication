//
//  StatisticsController.swift
//  FitnessTrackerApplication
//
//  Created by Anthony Rella on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.
//
//  StatisticsController is a view controller class that graphically displays the tracked workouts. It organizes the data by workout and month. As well as reps, sets, weight and duration

import UIKit
import Charts

class StatisticsController: UIViewController, ChartViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //declare all variables that will connect to the UI elements on the StatisticsController view controller
    @IBOutlet var chartView: LineChartView!
    @IBOutlet var metricSeg: UISegmentedControl!
    @IBOutlet var pickerView: UIPickerView!
    
    //sets the month and workout defaults for their picker views
    var monthDefault = 0
    var woDefault = 0
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    
    var monthWO = [NSInteger]()
    
    //sets up 2 components for picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //sets the size and style of the text in each picker view component
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
    
    //sets the displayed text for each picker view componenet. Workout name and Months
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
    
    //sets up the number of rows in each picker view based off of the number of workouts and number of months
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
    
    //action for when a selection is made by the picker view components. It will update the data from the generateLineDate method
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0){
            
            self.generateLineData(metric: 0, month: monthDefault, workoutN: row)
        }
        if(component == 1){
            
            self.generateLineData(metric: 0, month: row, workoutN: woDefault)
        }
        
    }
    
    //action for when the user selects a different workout metric type from the segmented control
    @IBAction func metricChanged(sender : UISegmentedControl){
        
        var metric : NSInteger = sender.selectedSegmentIndex
        generateLineData(metric: metric, month: monthDefault, workoutN: woDefault)
    }
    
    //initializes chart formatting data upon StatisticsController loading
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
    
    //creates the line chart
    func generateLineData(metric : NSInteger, month: NSInteger, workoutN: NSInteger) {
        
         monthDefault = month
         woDefault = workoutN
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        var w : WorkoutTracking = .init()
        var entries = [ChartDataEntry]()
        var wi : WorkoutInfo = .init()
        var metricType : String = ""
        
                //loops through each workout saved in delegate
                for (n, _) in mainDelegate.workouts.enumerated() {
                    
                    
                    w = mainDelegate.workouts.object(at: n) as! WorkoutTracking
                    
                    //matches a workout with the workout name that was selected from picker view
                    if(workoutN == Int(w.wID)){
                        
                        //matches the workout metric type that has been selected by user from segnmented control
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
                        //extracts the specific day number from date field
                        let dayNumber = Int(w.date.suffix(2))
                        
                        //sets default to graph incase data for day number or metric type is null
                        if(dayNumber == nil){
                            entries.append(ChartDataEntry(x: 0.0, y: 0.0))
                        }
                        if(metricType == ""){
                            entries.append(ChartDataEntry(x: 0.0, y: 0.0))
                        }
                        
                        //extracts month value from date field
                        var indexStartOfText = w.date.index(w.date.startIndex, offsetBy: 5)
                        var indexEndOfText = w.date.index(w.date.endIndex, offsetBy: -3)
                        
                        var substringDate = Int(w.date[indexStartOfText..<indexEndOfText])
                        
                        //appends point of data to line chart based off of the day number and the selected metric type
                        if(month == substringDate!){
                        
                        entries.append(ChartDataEntry(x: Double((dayNumber)!), y: (Double(metricType))!))
                        
                    }
                }
                
                //creates the data set for line chart
                let set = LineChartDataSet(values: entries, label: "Metric Values")
                
                //formats the line chart
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
                
                //appends the data to the line chart
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

