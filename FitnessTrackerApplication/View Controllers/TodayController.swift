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
    
    var activeEnergy: Double = 0.0
    
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
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
            //HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)!
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
            
        }
    }
    
    func readFromHealthKit() -> (age: Int?, bloodType: HKBloodTypeObject, activeEnergy: Double){
        var age: Int?
        var bloodType: HKBloodTypeObject?
        // var exerciseTime: Int?
        var energyBurned: Double = 0.0
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

        print("Active Energy \(energyBurned)")
        return (age, bloodType!, energyBurned)
    }

    @IBAction func getDetails(sender: UIButton) {
        let (age, bloodType, activeEnergy) = readFromHealthKit()
        self.lbAge.text = "Age: \(age ?? 0) years"
        self.lbBloodType.text = "Blood Type: bloodType"
        self.lbActiveEnergyBurned.text = "ActiveEnergyBurned: \(activeEnergy) calories"
        //need to write a method (switch statement) to convert bloodtype object to values like A+, etc.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
