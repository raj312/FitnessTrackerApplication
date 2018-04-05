//
//  TodayController.swift
//  FitnessTrackerApplication
//
//  Created by Xcode User on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.
//

import UIKit
import HealthKit

let healthkitStore:HKHealthStore = HKHealthStore()

class TodayController: UIViewController {
    
    @IBOutlet var lbAge: UILabel!
    @IBOutlet var lbBloodType: UILabel!
    @IBOutlet var lbActiveEnergyBurned: UILabel!
    @IBOutlet var lbDailySteps: UILabel!
    @IBOutlet var lbDistanceWalkingRunning: UILabel!
    @IBOutlet var lbAverageHeartRate: UILabel!
    @IBOutlet var lbMaximumHeartRate: UILabel!
    
    
    var activeEnergy: Double = 0.0
    var dailySteps: Double? = 0.0
    var totalDistance: Double? = 0.0
    var maxHeartRate: Double? = 0.0
    var avgHeartRate: Double? = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //run authorize healthkit code once the view loads
        self.authorizeHealthKit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Healthkit methods
    //requesting for permissions from the user
    func authorizeHealthKit(){
        
        let healthKitTypesRead : Set<HKObjectType> = [
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        ]
        let healthKitTypesWrite : Set<HKSampleType> = []
        
        if !HKHealthStore.isHealthDataAvailable() {
            print("Error occured")
            return
        }
        
        healthkitStore.requestAuthorization(toShare: healthKitTypesWrite, read: healthKitTypesRead) {
            (success, error) -> Void in
            print("Read Write Authorisation succeeded")
            //calculate active enerrgy
            self.getActiveEnergy()
            //get steps
            self.getStepCount()
            //get distance
            self.getDistanceWalkingRunning()
            //get heart rates
            self.getTodaysHeartRates()
        }
    }
    
    func readFromHealthKit() -> (age: Int?, bloodType: HKBloodTypeObject, activeEnergy: Double, steps: Double, activeDistance: Double, averageHeartRate: Double, maximumHeartRate: Double){
        var age: Int?
        var bloodType: HKBloodTypeObject?
        // var exerciseTime: Int?
        var energyBurned: Double = 0.0
        var steps: Double = 0.0
        var activeDistance: Double = 0.0
        var averageHeartRate: Double = 0.0
        var maximumHeartRate: Double = 0.0
        //calculate age
        do {
            let birthDay = try healthkitStore.dateOfBirthComponents()
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date())
            age = currentYear - birthDay.year!
        }catch{}
        
        //read blood type
        do {
            bloodType = try healthkitStore.bloodType()
        } catch{}
        
        //read active energy in kCal
        energyBurned = self.activeEnergy * 1000
        //read steps
        steps = self.dailySteps!
        //read distance covered while walking and running
        activeDistance = self.totalDistance!
        //get heart rate values
        averageHeartRate = self.avgHeartRate!
        maximumHeartRate = self.maxHeartRate!
        
        // print("Active Energy \(energyBurned)")
        // print("Daily steps \(steps)")
        return (age, bloodType!, energyBurned, steps, activeDistance, avgHeartRate!, maxHeartRate!)
    }

    @IBAction func getDetails(sender: UIButton) {
        let (age, bloodType, activeEnergy, steps, activeDistance, averageHeartRate, maximumHeartRate) = readFromHealthKit()
        self.lbAge.text = "Age: \(age ?? 0) years"
        self.lbBloodType.text = "Blood Type: bloodType"
        self.lbActiveEnergyBurned.text = "ActiveEnergyBurned: \(activeEnergy) calories"
        self.lbDailySteps.text = "Daily Steps: \(steps)"
        self.lbDistanceWalkingRunning.text = "Walking & Running Distance: \(activeDistance) miles"
        self.lbAverageHeartRate.text = "Average Heart Rate: \(averageHeartRate) beats/minute"
        self.lbMaximumHeartRate.text = "Maximum Heart Rate: \(maximumHeartRate) beats/minute"
    }

    func getActiveEnergy ()  {
        var todayActiveEnergy: Double = 0.0
        
        let starDate: Date = Calendar.current.startOfDay(for: Date())
        let endDate: Date = Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: starDate)!
        
        let activeEnergySampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: starDate, end: endDate, options: [])
        
        // print ("start date: ", starDate)
        // print ("end date: ", endDate)
        
        let query = HKSampleQuery(sampleType: activeEnergySampleType!, predicate: predicate, limit: 0, sortDescriptors: nil, resultsHandler: {
            (query, results, error) in
            if results == nil {
                print("There was an error running the query: \(error)")
            }
            self.activeEnergy = 0.0
            DispatchQueue.main.sync() {
                
                for activity in results as! [HKQuantitySample]
                {
                    todayActiveEnergy = activity.quantity.doubleValue(for: HKUnit.kilocalorie())
                    print(todayActiveEnergy)
                    self.activeEnergy += todayActiveEnergy
                }
            }
        })
        healthkitStore.execute(query)
//        return totalActiveEnergy
    }
    
    //get steps for the day
    func getStepCount() {
        let stepCount = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let calendar = NSCalendar.current
        let interval = NSDateComponents()
        interval.day = 1
        
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: NSDate() as Date)
        let anchorDate = calendar.date(from: anchorComponents)
        let stepsQuery = HKStatisticsCollectionQuery(quantityType: stepCount!, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval as DateComponents)
        
        stepsQuery.initialResultsHandler = {query, results, error in
            if (error != nil) {
                print(error as Any)
                print("In here")
            }
            let endDate = NSDate()
            
            var steps = 0.0
            let startDate = calendar.date(byAdding: .day, value: 0, to: endDate as Date)
            if let myResults = results{  myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
                if let quantity = statistics.sumQuantity(){
                    let date = statistics.startDate
                    steps = quantity.doubleValue(for: HKUnit.count())
                    print("\(date): steps = \(steps)")
                    self.dailySteps = steps
                }
                }
            }
        }
        healthkitStore.execute(stepsQuery)
    }
    
    //get miles walked for the day
    func getDistanceWalkingRunning() {
        let dist = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)
        let newDate: Date = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: newDate as Date, end: NSDate() as Date, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: dist!, quantitySamplePredicate: predicate, options: [.cumulativeSum]) { (query, statistics, error) in
            var value: Double = 0
            if (error != nil) {
                print("Error -> Miles distance took long")
            }
            if let totalDist = statistics?.sumQuantity() {
                value = totalDist.doubleValue(for: HKUnit.mile())
            }
            DispatchQueue.main.async {
                self.totalDistance = value
            }
        }
        healthkitStore.execute(query)
    }
    
    // Get today's Heart rate
    func getTodaysHeartRates()
    {
        let heartRate = HKSampleType.quantityType(forIdentifier: .heartRate)
        //predicate
        let newDate: Date = Calendar.current.startOfDay(for: Date())
        let calendar = NSCalendar.current
        let predicate = HKQuery.predicateForSamples(withStart: newDate, end: NSDate() as Date, options: [])
        let query = HKStatisticsQuery(quantityType: heartRate!, quantitySamplePredicate: predicate, options: [.discreteAverage, .discreteMax]) { (query, statistics, error) in
            var avgHeartRate: Double = 0
            var maxHeartRate: Double = 0
            if (error != nil) {
                print("Error -> heart rate could not be retrieved")
            }
            if let avgHeart = statistics?.averageQuantity() {
                avgHeartRate = Double(avgHeart.doubleValue(for: HKUnit(from: "count/s")) * 60)
                // print("Average heart rate: \(avgHeartRate)")
                self.avgHeartRate = avgHeartRate
            }
            if let maxHeart = statistics?.maximumQuantity() {
                maxHeartRate = Double(maxHeart.doubleValue(for: HKUnit(from: "count/s")) * 60)
                // print("Maximum Heart Rate: \(maxHeartRate)")
                self.maxHeartRate = maxHeartRate
            }
        }
        healthkitStore.execute(query)
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
