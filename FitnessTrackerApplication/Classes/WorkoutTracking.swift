//
//  WorkoutTracking.swift
//  FitnessTrackerApplication
//
//  Created by Xcode User on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.
//

import UIKit

class WorkoutTrackingg: NSObject {

    var workoutName: String = "Bench Press"
    var youtubeVideo: String = "https://www.youtube.com/embed/gRVjAtPip0Y?ecver=2"
    var reps: Double?
    var sets: Double?
    var weight: Double?
    var duration: Double?
    
    func saveData(reps : Double, sets: Double, weight: Double, duration: Double ){
        
        self.reps = reps
        self.sets = sets
        self.weight = weight
        self.duration = duration
    }
    
    func writeToDB()
    {
        print(self.reps, self.sets, self.weight, self.duration)
    }
    
}

