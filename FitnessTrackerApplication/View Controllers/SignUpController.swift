//
//  SignUpController.swift
//  FitnessTrackerApplication
//
//  Created by Raj Patel on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.
//

import UIKit

//View controller file associated with the register page
class SignUpController: UIViewController, UITextFieldDelegate {

    //declare all UI outlets here
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfUserName: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var tfConfirmPassword: UITextField!
    @IBOutlet var tfAddress: UITextField!
    @IBOutlet var lbGender: UILabel!
    @IBOutlet var switchGender: UISwitch!
    @IBOutlet var dpDateOfBirth: UIDatePicker!
    
    //global variable to be used by multiple methods
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
        let name = tfName.text
        let uName = tfUserName.text
        let uPass = tfPassword.text
        let uConfirmPass = tfConfirmPassword.text
        let address = tfAddress.text
        let gender = lbGender.text
        let dateOfBirth = dpDateOfBirth.date
        
        //format the date to string format to save it in database
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let sDateOfBirth: String = dateFormatter.string(from: dateOfBirth)
        
        //initialise the user Accoutn class to perform account actions like authenticate user input
        let userAccount: UserAccount = .init()
        
        //validate input
        // - All fields are compulsory
        let errorMessage: String = userAccount.validateInput(name: name!, username: uName!, password: uPass!, confirmPassword: uConfirmPass!, address: address!, gender: gender!, dateOfBirth: sDateOfBirth)
        if (errorMessage == "") { //no error returned - input is valid
            //create a user account object with data
            let user: User = .init()
            user.name = name
            user.username = uName
            user.password = uPass
            user.confirmPassword = uConfirmPass
            user.address = address
            user.gender = gender
            user.dateOfBirth = sDateOfBirth
            
            // insert userinput in users table in the database. dataAccess class containns the db logic
            let da: DataAccess = .init()
            //the insert method returns true id the user is inserted
            let returnCode: Bool = da.insert(intoDatabase: user)
            var returnMsg:String = "Person Added"
            if (returnCode == false) {
                returnMsg = "Person add Failed"
            }else{
                //if user is registered, show alert and redirect to home page
                showAlert(showTitle: "Sign up Complete", userMessage: "You can now use the fitness tracker application to keep up with your fitness goals", segueToDo: "ChooseSegueSignupToHome")
            }
        }else {
            //if user input was valid, notify the user and return to the register page
            showAlert(showTitle: "Error", userMessage: errorMessage, segueToDo: "")
        }
    }
    
    //show an alert with appropriate message -- Custom alert that takes in title, message to display and what segue to perform
    func showAlert(showTitle: String, userMessage: String, segueToDo: String) {
        let alert = UIAlertController(title: showTitle, message: userMessage, preferredStyle: .alert)
        
        // note the yes button has a handler declared inline
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
            if (segueToDo == "") {
                //do nothing
            }else{
                //performs segue if it was specified
                self.performSegue(withIdentifier: segueToDo, sender: self)
            }
            //self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        present(alert, animated: true)
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
