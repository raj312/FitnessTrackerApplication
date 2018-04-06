//
//  SignUpController.swift
//  FitnessTrackerApplication
//
//  Created by Xcode User on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.
//

import UIKit

class SignUpController: UIViewController, UITextFieldDelegate {

    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfUserName: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var tfConfirmPassword: UITextField!
    @IBOutlet var tfAddress: UITextField!
    @IBOutlet var lbGender: UILabel!
    @IBOutlet var switchGender: UISwitch!
    @IBOutlet var dpDateOfBirth: UIDatePicker!
    
    var errorMessage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //function to hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    //function to change gender when the switch is changed
    @IBAction func switchGenderChanged(sender: UISwitch) {
        if sender.isOn {
            lbGender.text = "Male"
        }else {
            lbGender.text = "Female"
        }
    }
    
    //retrieve all values when sign up is clicked
    @IBAction func getAllInput(sender: UIButton) {
        var name = tfName.text
        var uName = tfUserName.text
        var uPass = tfPassword.text
        var uConfirmPass = tfConfirmPassword.text
        var address = tfAddress.text
        var gender = lbGender.text
        var dateOfBirth = dpDateOfBirth.date
        
        //validate input
        // - All fields except username and password are optional
        validateInput(username: uName!, password: uPass!, confirmPassword: uConfirmPass!)
        
    }
    
    //show an alert with appropriate message
    func showAlert(userMessage: String) {
        let alert = UIAlertController(title: "Registration Failed", message: userMessage, preferredStyle: .alert)
        
        // note the yes button has a handler declared inline
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func validateInput(username: String, password: String, confirmPassword: String){
        var validateVal = 0
        if username == "" {
            print("Username must be provided")
            errorMessage += "\nUsername must be provided"
            validateVal = -1
        }
        //check if username is unique
        // -> Select Count(Name) as NumUsers from UsersDatabase where username = "userName"
        // if numUsers > 0, then username exists, return
        //else save the username
        let db: DataAccess = .init()
        let usernameExists: Bool = db.findUser(fromDatabase: username)
        //print(usernameExists)
        if(usernameExists) {
            errorMessage += "The username provided has already been taken"
        }
        //check if passwords are not empty
        if password == "" || confirmPassword == "" {
            print("Password and confirm password fields can not be left empty")
            errorMessage += "\nPassword and confirm password fields can not be left empty"
            validateVal = -1
        }
        //check if passowrds match
        if password == confirmPassword {
            print("Passwords match")
            //save the password to the database
        }else {
            errorMessage += "\nPassword and confirm password must match"
            validateVal = -1
        }
        
        if(validateVal == -1) {
            showAlert(userMessage: errorMessage)
        }else{
            print("Alls good")
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
