//
//  User.h
//  FitnessTrackerApplication
//
//  Created by Raj on 2018-04-18.
//  Copyright © 2018 RADS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject {
    NSString *name;
    NSString *username;
    NSString *password;
    NSString *confirmPassword;
    NSString *address;
    NSString *gender;
    NSString *dateOfBirth;
}
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *confirmPassword;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *gender;
@property(nonatomic, strong) NSString *dateOfBirth;

-(id)initWithData:(NSString *)name theUsername:(NSString *)username thePassword:(NSString *)password theConfirmPassword:(NSString *)confirmPassword theAddress:(NSString *)address theGender:(NSString *)gender theDateOfBirth:(NSString *)dateOfBirth;
@end
