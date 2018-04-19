//
//  TrackController.swift
//  FitnessTrackerApplication
//
//  Created by Xcode User on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.
//

import UIKit
import WebKit

class TrackController: UIViewController, WKNavigationDelegate {

    @IBOutlet var workoutNameLabel: UILabel!
    @IBOutlet var repsValue: UILabel!
    @IBOutlet var setsValue: UILabel!
    @IBOutlet var weightValue: UILabel!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var activity: UIActivityIndicatorView!
    @IBOutlet var time: UIDatePicker!
    
   
    @IBAction func repStepper(sender: UIStepper!){
        repsValue.text = String(Int(sender.value))
    }
    
    @IBAction func setStepper(sender: UIStepper!){
       
        setsValue.text = String(Int(sender.value))
    }
    @IBAction func weightStepper(sender: UIStepper!){
        weightValue.text = String(Int(sender.value))
    }

    @IBAction func saveDateButton(sender : UIButton!){
        
        let alert = UIAlertController(title: "Save Progress", message: "Do you wish to save your progress? ", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler:
    
            { (alert : UIAlertAction!) in
                self.doTheUpdate()
        }
        )
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true)
    }
    
    func doTheUpdate(){
         let workOutTracking : WorkoutTrackingg = .init()
        
         workOutTracking.saveData(reps: Double(repsValue.text!)!, sets: Double(setsValue.text!)!, weight: Double(weightValue.text!)!, duration: time.countDownDuration)
        
        workOutTracking.writeToDB()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let workOutTracking : WorkoutTrackingg = .init()
        workoutNameLabel.text = workOutTracking.workoutName

       let urlAddress = URL(string: workOutTracking.youtubeVideo)
       let url = URLRequest(url: urlAddress!)
       webView.load(url as URLRequest)
       webView.navigationDelegate = self
    }
    
 
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

        activity.startAnimating()
        activity.isHidden = false
    }

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
