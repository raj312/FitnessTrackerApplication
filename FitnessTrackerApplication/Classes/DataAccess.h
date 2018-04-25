//
//  DataAccess.h
//  FitnessTrackerApplication
//
//  Created by Raj Patel on 2018-04-06.
//  Copyright © 2018 RADS. All rights reserved.

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "User.h"

// A data access class that contains all the database methods for a user account like insert, read etc.

@interface DataAccess : NSObject {
    NSString *databaseName; //will hold the database Name
    NSString *databasePath; // contains where the database path is located
    NSMutableArray *users; // an array used to store multiple user' information
    NSString *imgDatabaseName;
    NSString *imgDatabasePath;
    NSMutableArray *photos;
}

@property (strong, nonatomic) NSString *databaseName;
@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) NSString *imgDatabaseName;
@property (strong, nonatomic) NSString *imgDatabasePath;
@property (strong, nonatomic) NSMutableArray *photos;

//documentation of the methods below is in the .m file (DataAccess.m)
-(BOOL)findUserFromDatabase:(NSString *) username;
-(NSString *)readDataAndAuthenticateUser:(NSString *)uname password:(NSString *)pass;
-(BOOL)insertIntoDatabase:(User *)user;
-(void)readDataFromImgDatabase;
-(void)checkAndCreateImgDatabase;
-(BOOL)insertIntoImgDatabase:(NSString *)imagePath;
@end
