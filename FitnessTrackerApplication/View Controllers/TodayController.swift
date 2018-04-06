//
//  TodayController.swift
//  FitnessTrackerApplication
//
//  Created by Xcode User on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.
//

import UIKit
import HealthKit

class TodayController: UIViewController {

    @IBOutlet var lbActiveEnergyBurned: UILabel!
    @IBOutlet var lbDailySteps: UILabel!
    @IBOutlet var lbDistanceWalkingRunning: UILabel!
    @IBOutlet var lbAverageHeartRate: UILabel!
    @IBOutlet var lbMaximumHeartRate: UILabel!
    @IBOutlet var lbMinimumHeartRate: UILabel!
    
    var activeEnergy: Double = 0.0
    var dailySteps: Double? = 0.0
    var totalDistance: Double? = 0.0
    var maxHeartRate: Double? = 0.0
    var avgHeartRate: Double? = 0.0
    var minHeartRate: Double? = 0.0
    
    let activity: DailyActivity = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //run authorize healthkit code once the view loads
        activity.authorizeHealthKit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //On button click, this function retrieves all values from the healthkit and displays them
    @IBAction func getDetails(sender: UIButton) {
        let (activeEnergy, steps, activeDistance, averageHeartRate, maximumHeartRate, minimumHeartRate) = activity.readFromHealthKit()
        self.lbActiveEnergyBurned.text = "ActiveEnergyBurned: \(activeEnergy) calories"
        self.lbDailySteps.text = "Daily Steps: \(steps)"
        self.lbDistanceWalkingRunning.text = "Walking & Running Distance: \(activeDistance) miles"
        self.lbAverageHeartRate.text = "Average Heart Rate: \(averageHeartRate) beats/minute"
        self.lbMaximumHeartRate.text = "Maximum Heart Rate: \(maximumHeartRate) beats/minute"
        self.lbMinimumHeartRate.text = "Minimum Heart rate: \(minimumHeartRate) beats/minute"
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
