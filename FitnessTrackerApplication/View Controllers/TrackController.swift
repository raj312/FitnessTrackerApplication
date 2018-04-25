//
//  TrackController.swift
//  FitnessTrackerApplication
//
//  Created by Anthony Rella on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.
//
//  TrackController is viewcontroller class used to manage the users input when tracking their workout session. Class consists of various selectors for inputs and a web view to display workout video.

import UIKit
import WebKit

class TrackController: UIViewController, WKNavigationDelegate {
    
    //declare all variables that will connect to the UI elements on the TrackController view controller
    @IBOutlet var workoutNameLabel: UILabel!
    @IBOutlet var repsValue: UILabel!
    @IBOutlet var setsValue: UILabel!
    @IBOutlet var weightValue: UILabel!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var activity: UIActivityIndicatorView!
    @IBOutlet var time: UIDatePicker!
    @IBOutlet var date: UIDatePicker!
    
    //action to change the reps stepper when user interacts with stepper
    @IBAction func repStepper(sender: UIStepper!){
        repsValue.text = String(Int(sender.value))
    }
    
    //action to change the sets stepper when user interacts with stepper
    @IBAction func setStepper(sender: UIStepper!){
        
        setsValue.text = String(Int(sender.value))
    }
    //action to change the weight stepper when user interacts with stepper
    @IBAction func weightStepper(sender: UIStepper!){
        weightValue.text = String(Int(sender.value))
    }
    
    //action to call addSession method when user selects button to save their workout session
    @IBAction func saveDateButton(sender : UIButton!){
        
        self.addSession()
    }
    
    //will store workout session information into workoutdb.db
    func addSession()
    {
        //formats date and removes time signature
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        let birthdate = formatter.string(from: date.date)
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var workout : WorkoutTracking = WorkoutTracking()
        
        //stores workout session information from UI values in workout variable
        workout = WorkoutTracking.init(data: birthdate, reps: repsValue.text, weight: weightValue.text, sets: setsValue.text, duration: String(time.countDownDuration), wID: String(mainDelegate.workoutID))
        
        //setting up prompt after for save data confirmation
        var returnMsg = "Add \(workoutNameLabel.text!) workout session to Database?"
        
        let alert = UIAlertController(title: "Confirm", message: String(returnMsg), preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "YES", style: .default, handler: {(alert: UIAlertAction!) in
            
            //inserts workout data into workoutdb.db
            let returnCode: Bool = mainDelegate.insert(intoDatabase: workout)
            
            if(!returnCode){
                
                returnMsg = "Workout Session Add Failed"
                let badAlert = UIAlertController(title: "Error!", message: String(returnMsg), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Okay", style: .default, handler: {(alert: UIAlertAction!) in
                    self.dismiss(animated: true, completion: nil)
                })
                
                badAlert.addAction(okAction)
                
                self.present(badAlert, animated: true)
                
            }
            else
            {
                //success message after add
                returnMsg = "\(self.workoutNameLabel.text!) Workout Session Added"
                let badAlert = UIAlertController(title: "Success!", message: String(returnMsg), preferredStyle: .alert)
                
                //okay action to reset workout session values on UI
                let okAction = UIAlertAction(title: "Okay", style: .default, handler: {(alert: UIAlertAction!) in
                    
                    self.repsValue.text = nil
                    self.setsValue.text = nil
                    self.weightValue.text = nil
                    self.time.countDownDuration = 0.0
                    self.date.date = Date()
                    
                })
                
                badAlert.addAction(okAction)
                
                self.present(badAlert, animated: true)
                
            }
            
        })
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: {(alert: UIAlertAction!) in
            
        })
        
        alert.addAction(okayAction)
        alert.addAction(noAction)
        
        present(alert, animated: true)
        
    }
    
    //initializes delegate and workoutinfo variables to load tracking page with workout type selected from MyWorkoutsController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        var wi : WorkoutInfo = .init()
        
        //loops through objects in workoutinfo to find the id the matches the workoutID stored in app delegate from when the user selected their workout to track from MyWorkoutsController
        for(n, _) in mainDelegate.workoutInfo.enumerated(){
            
            
            wi = mainDelegate.workoutInfo.object(at: n) as! WorkoutInfo
            
            //when it matches, the name, and youtube url are set on the page
            if(Int(wi.workoutInfoID) == mainDelegate.workoutID){
                workoutNameLabel.text = wi.name
                
                
                let urlAddress = URL(string: "https://www.youtube.com/embed/\(wi.videoCode!)?ecver=2")
                let url = URLRequest(url: urlAddress!)
                webView.load(url as URLRequest)
                webView.navigationDelegate = self
                
            }
        }
    }
    
    //to start animating the activity indicator for youtube video
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        activity.startAnimating()
        activity.isHidden = false
    }
    
    //to finish animating the youtube activity indicator
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        activity.stopAnimating()
        activity.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
