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
        let uname = tfUserName.text
        let upass = tfPassword.text
        if uname==nil || upass==nil {
            print("Invalid Uname and Password")
            return
        }
        let ua: UserAccount = .init()
        let errorMessage = ua.authenticateUser(uname: uname!, upass: upass!)
        if (errorMessage == "") {
            performSegue(withIdentifier: "ChooseSegueToHome", sender: nil)
        }else {
            let alert = UIAlertController(title: "Invalid Login", message: errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true)
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
