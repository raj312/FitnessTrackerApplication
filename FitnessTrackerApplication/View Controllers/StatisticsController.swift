//
//  StatisticsController.swift
//  FitnessTrackerApplication
//
//  Created by Xcode User on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.
//

import UIKit
import Charts

class StatisticsController: UIViewController {
    
    @IBAction func unwindToThisStatisticsController(sender : UIStoryboardSegue){
        
    }
    @IBOutlet var workoutNameLabel: UILabel!
    @IBOutlet var barChart: BarChartView!
  
    
    @IBAction func segmentChoice (sender: UISegmentedControl){
        
        var segmentFlag = sender.selectedSegmentIndex
        barChartUpdate(segmentFlag)
    }
    
    func barChartUpdate (_ segmentFlag: Int) {
        
        let progressStatistics : ProgressStatistics = .init()
        let datas = progressStatistics.workoutDatas
        var entry = [BarChartDataEntry]()
        
        for (date, workout) in datas {
            
            entry.append(BarChartDataEntry(x: Double(date), y:Double(workout[segmentFlag])))
            
        }
        
        let dataSet = BarChartDataSet(values: entry, label: "Workouts")
        let data = BarChartData(dataSets: [dataSet])
        barChart.data = data
        barChart.chartDescription?.text = "1 Week"
        barChart.notifyDataSetChanged()
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

        let workOutTracking : WorkoutTracking = .init()
        workoutNameLabel.text = workOutTracking.workoutName
        barChartUpdate(0)
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
