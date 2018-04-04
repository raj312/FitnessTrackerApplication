//
//  LoginController.swift
//  FitnessTrackerApplication
//
//  Created by Xcode User on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var tfUserName: UITextField!
    @IBOutlet var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //function to hide keyboard after user hits the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    //unwind to controller
    @IBAction func unwindToThisLoginController(sender : UIStoryboardSegue){
        
    }
    
    //on login button click, authenticate user
    @IBAction func loginUser(sender: UIButton){
        var uname = tfUserName.text
        var upass = tfPassword.text
        if uname==nil || upass==nil {
            print("Invalid Uname and Pas")
            return
        }
        authenticateUser(uname: uname!, upass: upass!)
    }
    
    //get login rcredentials on click and authenticate the user
    func authenticateUser(uname: String, upass: String){
        //check the uname and upass against values in the database
        //for now i will be hardcoding
        if uname=="raj" && upass=="raj" {
            //send to home page
            performSegue(withIdentifier: "ChooseSegueToHome", sender: nil)
        }else{
            //notify the user that invalid login
            return
        }
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
