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
    func authorizeHealthKit(){
        
        let healthKitTypesRead : Set<HKObjectType> = [
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!
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
            
        }
    }
    
    func readFromHealthKit() -> (age: Int?, bloodType: HKBloodTypeObject){
        var age: Int?
        var bloodType: HKBloodTypeObject?
        // var exerciseTime: Int?
        
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
        
        return (age, bloodType!)
    }

    @IBAction func getDetails(sender: UIButton) {
        let (age, bloodType) = readFromHealthKit()
        self.lbAge.text = "Age: \(age ?? 0) years"
        self.lbBloodType.text = "Blood Type: bloodType"
        //need to write a method (switch statement) to convert bloodtype object to values like A+, etc.
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
