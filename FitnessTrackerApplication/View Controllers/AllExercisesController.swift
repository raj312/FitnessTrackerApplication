//
//  AllExercisesController.swift
//  FitnessTrackerApplication
//
//  Created by DeJoun Robinson on 2018-04-21.
//  Copyright © 2018 RADS. All rights reserved.
//

import UIKit

class AllExercisesController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var workouts: [WorkoutsDBManager.Workout]!
    
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        tblView.delegate = self
        tblView.dataSource = self
        tblView.backgroundView = UIImageView(image: UIImage(named: "workoutlistwallpaper.jpg"))
        workouts = WorkoutsDBManager.shared.getAllWorkouts()
        super.viewDidLoad()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return workouts.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell") as! MyWorkoutsCustomTableViewCell
        cell.layer.cornerRadius = cell.cellView.frame.height / 2
        
        let workout = workouts[indexPath.row]
        
        cell.lblWorkoutName.text = workout.name
        cell.id = workout.id
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selectedWorkout = workouts[indexPath.row].id
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
