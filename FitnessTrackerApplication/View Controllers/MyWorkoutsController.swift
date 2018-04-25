//
//  MyWorkoutsController.swift
//  FitnessTrackerApplication
//
//  Created by DeJoun Robinson on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.
//

import UIKit

class MyWorkoutsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //creates var of type Workout array
    var workouts: [WorkoutsDBManager.Workout]!
    //table view for workouts list
    @IBOutlet var tableView: UITableView!
    
    @IBAction func unwindToThisWorkoutsController(sender : UIStoryboardSegue){
    }
    
    //Prepares the table view to be displayed
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = UIImageView(image: UIImage(named: "workoutlistwallpaper.jpg"))
        //runs the DB query to supply the list
        workouts = WorkoutsDBManager.shared.getAllWorkouts()
        super.viewDidLoad()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //returns number of cells to generate based on number of workouts
        return workouts.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //allows cells to be reused as they leave and enter the display
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell") as! MyWorkoutsCustomTableViewCell
        //rounds the corners of the cell
        cell.layer.cornerRadius = cell.cellView.frame.height / 1.8
        
        //provides the workout data for this cell
        let workout = workouts[indexPath.row]
        
        //fills in workout name for cell
        cell.lblWorkoutName.text = workout.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //create a variable to reference appdelegate
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        //returns workoutID to appdelegate
        mainDelegate.workoutID = workouts[indexPath.row].id
        //segues to tracking page to view details for that workout
        self.performSegue(withIdentifier: "MyWorkoutsToTrackProgress", sender: indexPath);
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
