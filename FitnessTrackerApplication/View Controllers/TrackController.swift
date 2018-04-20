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
    @IBOutlet var date: UIDatePicker!
    
   
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
        
//        let alert = UIAlertController(title: "Save Progress", message: "Do you wish to save your progress? ", preferredStyle: .alert)
//
//        let yesAction = UIAlertAction(title: "Yes", style: .default, handler:
//
//            { (alert : UIAlertAction!) in
//                self.doTheUpdate()
//        }
//        )
//
//        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
//
//        alert.addAction(yesAction)
//        alert.addAction(noAction)
//
//        present(alert, animated: true)
        
         self.addUser()
    }
    
    
//    func doTheUpdate(){
//         let workOutTracking : WorkoutTrackingg = .init()
//
//
//
//         workOutTracking.saveData(reps: Double(repsValue.text!)!, sets: Double(setsValue.text!)!, weight: Double(weightValue.text!)!, duration: time.countDownDuration)
//
//        workOutTracking.writeToDB()
//    }
    
    
    func addUser()
    {
//        let avIndex = segAvatar.selectedSegmentIndex
//        let segIndex = switchGender.isOn
//        var gender = ""
//
//        if(segIndex){
//            gender = "Male"
//        }else{
//            gender = "Female"
//        }
//        var avatar:String = ""
//
//        switch avIndex {
//
//        case 0:
//            avatar = "face1.png"
//        case 1:
//            avatar = "face2.png"
//        case 2:
//            avatar = "face3.png"
//        default:
//            avatar = ""
//        }
        
        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd"

        let birthdate = formatter.string(from: date.date)

        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var workout : WorkoutTracking = WorkoutTracking()
        workout = WorkoutTracking.init(data: birthdate, reps: repsValue.text, weight: weightValue.text, sets: setsValue.text, duration: String(time.countDownDuration), wID: String(mainDelegate.workoutID))
        
        
        
        
        var returnMsg = "Add \(workoutNameLabel.text!) workout session to Database?"
        
        
        let alert = UIAlertController(title: "Confirm", message: String(returnMsg), preferredStyle: .alert)
        
        
        let okayAction = UIAlertAction(title: "YES", style: .default, handler: {(alert: UIAlertAction!) in
            
            let returnCode: Bool = mainDelegate.insert(intoDatabase: workout)
            
            if(!returnCode){
                
                returnMsg = "Workout Session Add Failed"
                let badAlert = UIAlertController(title: "Error!", message: String(returnMsg), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Okay", style: .default, handler: {(alert: UIAlertAction!) in
                    self.dismiss(animated: true, completion: nil)
                })
                
                badAlert.addAction(okAction)
                
                self.present(badAlert, animated: true)
                
            }else{
                
                returnMsg = "\(self.workoutNameLabel.text!) Workout Session Added"
                let badAlert = UIAlertController(title: "Success!", message: String(returnMsg), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Okay", style: .default, handler: {(alert: UIAlertAction!) in
                    
                    self.repsValue.text = nil
                    self.setsValue.text = nil
                    self.weightValue.text = nil
                    self.time.countDownDuration = 0.0
                    self.date.date = Date()
                    
//                    self.tfName.text = nil
//                    self.tfEmail.text = nil
//                    self.tfAddress.text = nil
//                    self.tfPhoneNumber.text = nil
//                    self.slAge.setValue(50, animated:true)
//                    self.lblAge.text = "50"
//                    self.switchGender.isOn = true
//                    self.birthdayPicker.date = Date()
//                    self.segAvatar.selectedSegmentIndex = 0
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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          let mainDelegate = UIApplication.shared.delegate as! AppDelegate
          var wi : WorkoutInfo = .init()
        
        
        for(n, _) in mainDelegate.workoutInfo.enumerated(){
            
            wi = mainDelegate.workoutInfo.object(at: n) as! WorkoutInfo
            
            if(Int(wi.workoutInfoID) == mainDelegate.workoutID){
                
                workoutNameLabel.text = wi.name
                
                
                let urlAddress = URL(string: "https://www.youtube.com/embed/\(wi.videoCode!)?ecver=2")
                let url = URLRequest(url: urlAddress!)
                webView.load(url as URLRequest)
                webView.navigationDelegate = self
                

                
                
                
                
            }
        }

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
