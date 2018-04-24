//
//  DailyActivity.swift
//  FitnessTrackerApplication
//
//  Created by Raj Patel on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.

import Foundation
import HealthKit

// This class deals with retrieving data from the health app

class DailyActivity: NSObject {
    //use this variable to communicate to the health app
    let healthkitStore:HKHealthStore = HKHealthStore()
    var activeEnergy: Double = 0.0
    var dailySteps: Double? = 0.0
    var totalDistance: Double? = 0.0
    var maxHeartRate: Double? = 0.0
    var avgHeartRate: Double? = 0.0
    var minHeartRate: Double? = 0.0
    
    // MARK: - Healthkit methods
    //requesting for permissions from the user for all the values we need to read from the health app
    func authorizeHealthKit(){
        //Set of all the values we will be reading from health app
        let healthKitTypesRead : Set<HKObjectType> = [
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        ]
        // Set of values we will write to the health app. For now, I won't be writing to the health data
        let healthKitTypesWrite : Set<HKSampleType> = []
        //check if health data/app exists
        if !HKHealthStore.isHealthDataAvailable() {
            print("Error occured")
            return
        }
        //Requesting permissions for all the values we will read/write to in the health app
        healthkitStore.requestAuthorization(toShare: healthKitTypesWrite, read: healthKitTypesRead) {
            (success, error) -> Void in
            // print("Read Write Authorisation succeeded")
            
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
    
    //Read data from healthkit
    func readFromHealthKit() -> (activeEnergy: Double, steps: Double, activeDistance: Double, averageHeartRate: Double, maximumHeartRate: Double, minimumHeartRate: Double){
        var energyBurned: Double = 0.0
        var steps: Double = 0.0
        var activeDistance: Double = 0.0
        var averageHeartRate: Double = 0.0
        var maximumHeartRate: Double = 0.0
        var minimumHeartRate: Double = 0.0
        
        //read active energy in kCal
        energyBurned = self.activeEnergy * 1000
        //read steps
        steps = self.dailySteps!
        //read distance covered while walking and running
        activeDistance = self.totalDistance!
        //get heart rate values
        averageHeartRate = self.avgHeartRate!
        maximumHeartRate = self.maxHeartRate!
        minimumHeartRate = self.minHeartRate!
        
        return (energyBurned, steps, activeDistance, averageHeartRate, maximumHeartRate, minimumHeartRate)
    }
    
    //Get active energy burned during the day
    func getActiveEnergy ()  {
        var todayActiveEnergy: Double = 0.0
        
        //get the start and end dates. In this case, since it is for today's activity, we will set startDay as today and end date to current day + 1
        let starDate: Date = Calendar.current.startOfDay(for: Date())
        let endDate: Date = Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: starDate)!
        
        //specifying the sample type required when retrieving this information
        let activeEnergySampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: starDate, end: endDate, options: [])
        
        //This function queries the health data for the required information related to active Energy burned
        let query = HKSampleQuery(sampleType: activeEnergySampleType!, predicate: predicate, limit: 0, sortDescriptors: nil, resultsHandler: {
            (query, results, error) in
            if results == nil {
                print("There was an error running the query: \(error)")
            }
            self.activeEnergy = 0.0
            //an asynchronous function to get all data for the day
            DispatchQueue.main.sync() {
                for activity in results as! [HKQuantitySample]
                {
                    todayActiveEnergy = activity.quantity.doubleValue(for: HKUnit.kilocalorie())
                    //print(todayActiveEnergy)
                    //Add up all the values to get the total energy burned during the day
                    self.activeEnergy += todayActiveEnergy
                }
            }
        })
        healthkitStore.execute(query)
    }
    
    //get steps for the day
    func getStepCount() {
        //specifying the sample type required when getting the steps for the day
        let stepCount = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        //setting the duration to 1 day
        let calendar = NSCalendar.current
        let interval = NSDateComponents()
        interval.day = 1
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: NSDate() as Date)
        let anchorDate = calendar.date(from: anchorComponents)
        //Function queries the healt data for the steps
        let stepsQuery = HKStatisticsCollectionQuery(quantityType: stepCount!, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval as DateComponents)
        
        stepsQuery.initialResultsHandler = {query, results, error in
            if (error != nil) {
                print(error as Any)
            }
            let endDate = NSDate()
            
            var steps = 0.0
            let startDate = calendar.date(byAdding: .day, value: 0, to: endDate as Date)
            if let myResults = results {
                //enumerate statistics is used since we will be using the sum function to get the sum of  all the steps taken
                myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        let date = statistics.startDate
                        steps = quantity.doubleValue(for: HKUnit.count())
                        //set the global variable dailySteps with the steps value
                        self.dailySteps = steps
                    }
                }
            }
        }
        healthkitStore.execute(stepsQuery)
    }
    
    //get miles walked for the day
    func getDistanceWalkingRunning() {
        //Specify the quantity type for the active distance (walking and running) metric
        let dist = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)
        //specify the date/duration. I will be setting it to today
        let newDate: Date = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: newDate as Date, end: NSDate() as Date, options: .strictStartDate)
        //Queries the health data for the active distance covered during the entire day
        let query = HKStatisticsQuery(quantityType: dist!, quantitySamplePredicate: predicate, options: [.cumulativeSum]) { (query, statistics, error) in
            var value: Double = 0
            if (error != nil) {
                print("Error -> Miles distance took long")
            }
            //Summing up the distance covered and getting it in miles.
            if let totalDist = statistics?.sumQuantity() {
                value = totalDist.doubleValue(for: HKUnit.mile())
            }
            DispatchQueue.main.async {
                //set the active distance to a global variable so it can be used by other methods
                self.totalDistance = value
            }
        }
        healthkitStore.execute(query)
    }
    
    // Get today's Heart rate
    func getTodaysHeartRates()
    {
        //quantity type for the heart rate
        let heartRate = HKSampleType.quantityType(forIdentifier: .heartRate)
        //predicate
        let newDate: Date = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: newDate, end: NSDate() as Date, options: [])
        //Query the health data to get the heart rate information for today
        //Use statistics query since we will perform statistics functions like max, min, average
        let query = HKStatisticsQuery(quantityType: heartRate!, quantitySamplePredicate: predicate, options: [.discreteAverage, .discreteMax, .discreteMin]) { (query, statistics, error) in
            var avgHeartRate: Double = 0
            var maxHeartRate: Double = 0
            var minHeartRate: Double = 0
            if (error != nil) {
                print("Error -> heart rate could not be retrieved")
            }
            //get average heart rate for the day. Average Function computes this automatically
            if let avgHeart = statistics?.averageQuantity() {
                avgHeartRate = Double(avgHeart.doubleValue(for: HKUnit(from: "count/s")) * 60)
                self.avgHeartRate = avgHeartRate
            }
            //get the maximum heart rate for the day. Units are in counts per minute
            if let maxHeart = statistics?.maximumQuantity() {
                maxHeartRate = Double(maxHeart.doubleValue(for: HKUnit(from: "count/s")) * 60)
                self.maxHeartRate = maxHeartRate
            }
            //get the minimum heart rate for the day. Covert the result to counts/minute
            if let minHeart = statistics?.minimumQuantity(){
                minHeartRate = Double(minHeart.doubleValue(for: HKUnit(from: "count/s")) * 60)
                self.minHeartRate = minHeartRate
            }
        }
        healthkitStore.execute(query)
    }

}
