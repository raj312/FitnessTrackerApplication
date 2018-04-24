//
//  UserAccount.swift
//  FitnessTrackerApplication
//
//  Created by Raj Patel on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.

// This class handles user authentication and login/registration input

import Foundation;

class UserAccount: NSObject {

    // validates user input from the register page
    // Checks if username is unique, passwords match and all fields are provided
    func validateInput(name: String, username: String, password: String, confirmPassword: String, address: String, gender: String, dateOfBirth: String) -> String {
        var errorMessage = ""
        if username == "" {
            print("Username must be provided")
            errorMessage += "\nUsername must be provided"
        }
        //check if username is unique
        let db: DataAccess = .init()
        let usernameExists: Bool = db.findUser(fromDatabase: username)
        if(usernameExists) {
            errorMessage += "The username provided has already been taken"
        }
        //check if passwords are empty
        if password == "" || confirmPassword == "" {
            print("Password and confirm password fields can not be left empty")
            errorMessage += "\nPassword and confirm password fields can not be left empty"
        }
        //check if passwords match
        if password == confirmPassword {
            //print("Passwords match")
        }else {
            errorMessage += "\nPassword and confirm password must match"
        }
        
        //all form fields are compuslory
        if address == "" || gender == "" || dateOfBirth == "" {
            print("All fields are compulsory")
            errorMessage += "\nAll fields must be filled"
        }
        return errorMessage
    }
 
    //get login credentials on click and authenticate the user
    func authenticateUser(uname: String, upass: String) -> String{
        var errorMssg: String = ""
        //check the uname and upass against values in the database
        let da: DataAccess = .init()
        errorMssg = da.readDataAndAuthenticateUser(uname, password: upass)
        //print(userIsValid)
        return errorMssg
    }
}
