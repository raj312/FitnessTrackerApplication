//
//  MyWorkoutsController.swift
//  FitnessTrackerApplication
//
//  Created by Xcode User on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.
//

import UIKit

class MyWorkoutsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var workouts: [WorkoutsDBManager.Workout]!
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func unwindToThisWorkoutsController(sender : UIStoryboardSegue){
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = UIImageView(image: UIImage(named: "workoutlistwallpaper.jpg"))
        workouts = WorkoutsDBManager.shared.getAllWorkouts()
        super.viewDidLoad()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return workouts.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell") as! MyWorkoutsCustomTableViewCell
        cell.layer.cornerRadius = cell.cellView.frame.height / 1.8
        
        let workout = workouts[indexPath.row]
        
        cell.lblWorkoutName.text = workout.name
        cell.id = workout.id
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        mainDelegate.workoutID = workouts[indexPath.row].id
        
        self.performSegue(withIdentifier: "MyWorkoutsToTrackProgress", sender: indexPath);
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
