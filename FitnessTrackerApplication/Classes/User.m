//
//  User.m
//  FitnessTrackerApplication
//
//  Created by Raj Patel on 2018-04-18.
//  Copyright © 2018 RADS. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize name, username, password, confirmPassword, address, gender, dateOfBirth; // getters and setters

//constructor takes in various properties and initialises the User object
-(id)initWithData:(NSString *)name theUsername:(NSString *)username thePassword:(NSString *)password theConfirmPassword:(NSString *)confirmPassword theAddress:(NSString *)address theGender:(NSString *)gender theDateOfBirth:(NSString *)dateOfBirth {
    //call the super/parent class constructor
    if(self = [super init]){
        self.name = name;
        self.username = username;
        self.password = password;
        self.confirmPassword = confirmPassword;
        self.address = address;
        self.gender = gender;
        self.dateOfBirth = dateOfBirth;
    }
    return self;
}
@end
