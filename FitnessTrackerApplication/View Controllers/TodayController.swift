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
    @IBOutlet var lbHeartRate: UILabel!
    
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
        lbHeartRate.text = "0 bpm"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //On button click, this function retrieves all values from the healthkit and displays them
    @IBAction func getDetails(sender: UIButton) {
        let (activeEnergy, steps, activeDistance, averageHeartRate, maximumHeartRate, minimumHeartRate) = activity.readFromHealthKit()
        self.lbActiveEnergyBurned.text = "\(activeEnergy)"
        self.lbDailySteps.text = "\(steps)"
        self.lbDistanceWalkingRunning.text = "\(activeDistance)"
        self.avgHeartRate = averageHeartRate
        self.maxHeartRate = maximumHeartRate
        self.minHeartRate = minimumHeartRate
    }
    
    @IBAction func getHeartRateSegmentedControl(sender: UISegmentedControl){
        let nf = NumberFormatter()
        nf.numberStyle = NumberFormatter.Style.decimal
        nf.maximumFractionDigits = 2
        switch sender.selectedSegmentIndex {
        case 0:
            lbHeartRate.text = nf.string(from: minHeartRate! as NSNumber)
            break
        case 1:
            lbHeartRate.text = nf.string(from: avgHeartRate! as NSNumber)
            break
        case 2:
            lbHeartRate.text = nf.string(from: maxHeartRate! as NSNumber)
            break
        default:
            break
        }
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
