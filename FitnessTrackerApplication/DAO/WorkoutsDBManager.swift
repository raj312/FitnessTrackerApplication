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
    
    struct workout {
        var id: Int!
        var name: String!
    }
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        
        pathToDatabase = documentsDirectory.appendingFormat("/" + databaseFileName)
        print(pathToDatabase)
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            print("DB Exists")
        } else {
            let dbSource = Bundle.main.url(forResource: "data", withExtension:"db")
            print("START - \(String(describing: dbSource)) - END")
            let dbDestination = URL(string: "file://" + pathToDatabase)
            print("START - \(String(describing: dbDestination)) - END")
            do{
                try FileManager.default.copyItem(at: dbSource!, to: dbDestination!)
                print("DB File Copied")
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
}
