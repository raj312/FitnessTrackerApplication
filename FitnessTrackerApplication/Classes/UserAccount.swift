//
//  UserAccount.swift
//  FitnessTrackerApplication
//
//  Created by Xcode User on 2018-03-27.
//  Copyright © 2018 RADS. All rights reserved.
//

import Foundation;

class UserAccount: NSObject {

    func validateInput(name: String, username: String, password: String, confirmPassword: String, address: String, gender: String, dateOfBirth: String) -> String {
        var errorMessage = ""
        if username == "" {
            print("Username must be provided")
            errorMessage += "\nUsername must be provided"
        }
        //check if username is unique
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
        }
        //check if passowrds match
        if password == confirmPassword {
            print("Passwords match")
            //save the password to the database
        }else {
            errorMessage += "\nPassword and confirm password must match"
        }
        if address == "" || gender == "" || dateOfBirth == "" {
            print("All fields are compulsory")
            errorMessage += "\nAll fields must be filled"
        }
        return errorMessage
    }
 
    //get login rcredentials on click and authenticate the user
    func authenticateUser(uname: String, upass: String) -> String{
        var errorMssg: String = ""
        //check the uname and upass against values in the database
        //for now i will be hardcoding
        let da: DataAccess = .init()
        errorMssg = da.readDataAndAuthenticateUser(uname, password: upass)
        //print(userIsValid)
        return errorMssg
    }
}
