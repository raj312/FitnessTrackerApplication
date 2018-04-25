//
//  WorkoutsDBManager.swift
//  FitnessTrackerApplication
//
//  Created by DeJoun Robinson on 2018-04-18.
//  Copyright © 2018 RADS. All rights reserved.
//

import UIKit

class WorkoutsDBManager: NSObject {
    static let shared: WorkoutsDBManager = WorkoutsDBManager()
    
    let databaseFileName = "workoutdb.db"
    var pathToDatabase: String!
    var database: FMDatabase!
    
    let fieldId = "id"
    let fieldName = "name"
    
    struct Workout {
        var id: Int!
        var name: String!
    }
    
    override init() {
        super.init()
        
        //Find documents directory on device
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        
        //Create path to DB using documents directory
        pathToDatabase = documentsDirectory.appendingFormat("/" + databaseFileName)
        
        //Check if the db file already exists
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            //DB exists no action required
        } else {
            //Find db in app bundle
            let dbSource = Bundle.main.url(forResource: "workoutdb", withExtension:"db")
            //Find destination
            let dbDestination = URL(string: "file://" + pathToDatabase)
            do{
                //Copies db from app bundle to documents directory
                try FileManager.default.copyItem(at: dbSource!, to: dbDestination!)
            }catch{
                //error sent to console
                print("DB File Not Copied: \(error)")
            }
        }
        //creates the db object if it is not created
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
    }
    
    //Opens db for querying
    func openDatabase() -> Bool {
        if database != nil {
            //confirms if db was opened
            if database.open() {
                return true
            }
        }
        //if it is unable to open the connection, returns false
        return false
    }
    
    //retrieve all workouts from db
    func getAllWorkouts() -> [Workout]!{
        var workouts: [Workout] = [Workout]()
        if openDatabase() {
            //query to sort all workouts in alphabetical order
            let query = "select * from workout order by \(fieldName) asc"
            do {
                //Executes query and stores query results
                let results = try database.executeQuery(query, values: nil)
                
                //loops through results and appends them to an array of struct Workout
                while results.next() {
                    let workout = Workout(id: Int(results.int(forColumn: fieldId)),
                                    name: results.string(forColumn: fieldName)
                    )
                    workouts.append(workout)
                }
            }
            catch {
                //send error to console
                print("Unable to get users: \(error)")
            }
            //close db after getting all workouts
            database.close()
        }
        //return array of workouts
        return workouts
    }
}
