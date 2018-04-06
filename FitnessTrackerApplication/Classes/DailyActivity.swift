//
//  DailyActivity.swift
//  FitnessTrackerApplication
//
//  Created by Xcode User on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.
//

import Foundation
import HealthKit


class DailyActivity: NSObject {
    let healthkitStore:HKHealthStore = HKHealthStore()
    var activeEnergy: Double = 0.0
    var dailySteps: Double? = 0.0
    var totalDistance: Double? = 0.0
    var maxHeartRate: Double? = 0.0
    var avgHeartRate: Double? = 0.0
    var minHeartRate: Double? = 0.0
    
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
    func readFromHealthKit() -> (age: Int?, bloodType: HKBloodTypeObject, activeEnergy: Double, steps: Double, activeDistance: Double, averageHeartRate: Double, maximumHeartRate: Double, minimumHeartRate: Double){
        var age: Int?
        var bloodType: HKBloodTypeObject?
        var energyBurned: Double = 0.0
        var steps: Double = 0.0
        var activeDistance: Double = 0.0
        var averageHeartRate: Double = 0.0
        var maximumHeartRate: Double = 0.0
        var minimumHeartRate: Double = 0.0
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
        minimumHeartRate = self.minHeartRate!
        
        return (age, bloodType!, energyBurned, steps, activeDistance, averageHeartRate, maximumHeartRate, minimumHeartRate)
    }
    
    //Get active energy burned for the day
    func getActiveEnergy ()  {
        var todayActiveEnergy: Double = 0.0
        let starDate: Date = Calendar.current.startOfDay(for: Date())
        let endDate: Date = Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: starDate)!
        
        let activeEnergySampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: starDate, end: endDate, options: [])
        
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
            }
            let endDate = NSDate()
            
            var steps = 0.0
            let startDate = calendar.date(byAdding: .day, value: 0, to: endDate as Date)
            if let myResults = results {
                myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        let date = statistics.startDate
                        steps = quantity.doubleValue(for: HKUnit.count())
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
        let predicate = HKQuery.predicateForSamples(withStart: newDate, end: NSDate() as Date, options: [])
        let query = HKStatisticsQuery(quantityType: heartRate!, quantitySamplePredicate: predicate, options: [.discreteAverage, .discreteMax, .discreteMin]) { (query, statistics, error) in
            var avgHeartRate: Double = 0
            var maxHeartRate: Double = 0
            var minHeartRate: Double = 0
            if (error != nil) {
                print("Error -> heart rate could not be retrieved")
            }
            if let avgHeart = statistics?.averageQuantity() {
                avgHeartRate = Double(avgHeart.doubleValue(for: HKUnit(from: "count/s")) * 60)
                self.avgHeartRate = avgHeartRate
            }
            if let maxHeart = statistics?.maximumQuantity() {
                maxHeartRate = Double(maxHeart.doubleValue(for: HKUnit(from: "count/s")) * 60)
                self.maxHeartRate = maxHeartRate
            }
            if let minHeart = statistics?.minimumQuantity(){
                minHeartRate = Double(minHeart.doubleValue(for: HKUnit(from: "count/s")) * 60)
                self.minHeartRate = minHeartRate
            }
        }
        healthkitStore.execute(query)
    }
    

}
