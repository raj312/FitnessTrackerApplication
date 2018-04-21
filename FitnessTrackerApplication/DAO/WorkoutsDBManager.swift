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
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        
        pathToDatabase = documentsDirectory.appendingFormat("/" + databaseFileName)
        print(pathToDatabase)
        if FileManager.default.fileExists(atPath: pathToDatabase) {
        } else {
            let dbSource = Bundle.main.url(forResource: "workoutdb", withExtension:"db")
            let dbDestination = URL(string: "file://" + pathToDatabase)
            do{
                try FileManager.default.copyItem(at: dbSource!, to: dbDestination!)
            }catch{
                print("DB File Not Copied: \(error)")
            }
        }
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
    }
    
    func openDatabase() -> Bool {
        if database != nil {
            if database.open() {
                return true
            }
        }
        return false
    }
    
    func getAllWorkouts() -> [Workout]!{
        var workouts: [Workout] = [Workout]()
        if openDatabase() {
            let query = "select * from workout order by \(fieldName) asc"
            do {
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let workout = Workout(id: Int(results.int(forColumn: fieldId)),
                                    name: results.string(forColumn: fieldName)
                    )
                    workouts.append(workout)
                }
            }
            catch {
                print("Unable to get users: \(error)")
            }
            database.close()
        }
        return workouts
    }
    
    func getMyWorkouts() -> [Workout]!{
        var workouts: [Workout] = [Workout]()
        if openDatabase() {
            let query = "select * from workout where added=1 order by \(fieldName) asc"
            do {
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let workout = Workout(id: Int(results.int(forColumn: fieldId)),
                                          name: results.string(forColumn: fieldName)
                    )
                    workouts.append(workout)
                }
            }
            catch {
                print("Unable to get workouts: \(error)")
            }
            database.close()
        }
        return workouts
    }
    
    func updateAddedStatus(id : Int) -> Bool{
        if openDatabase() {
            let query = "update workout set added=1 where \(fieldId)=\(id)"
            if !database.executeStatements(query) {
                print(database.lastError(), database.lastErrorMessage())
                database.close();
                return false;
            }
            database.close();
            return true
        }
        return false
    }
}
