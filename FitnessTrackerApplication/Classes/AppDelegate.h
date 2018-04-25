//
//  AppDelegate.h
//  FitnessTrackerApplication
//
//  Created by Anthony Rella on 2018-04-16.
//  Copyright © 2018 Xcode User. All rights reserved.
//
//  App Delegate header containing all the field and method declarations. Primary purpose of class is for database access
//      to workoutdb.db, and storage of workout and session data.

#import <UIKit/UIKit.h>
#import "WorkoutTracking.h"
#import "WorkoutInfo.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *databaseName; //will hold the database name
    NSString *databasePath; // contains where the database path is located
    NSMutableArray *workouts; //will contain an array of objects containing information from tracking a workout
    NSInteger workoutID; //will contain the unique id of the selected workout passed from the MyWorkoutsController
    NSMutableArray *workoutInfo; //will contain an array of objects containing a workout type
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *databaseName;
@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) NSMutableArray *workouts;
@property (strong, nonatomic) NSMutableArray *workoutInfo;
@property NSInteger workoutID;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSString *path;

//documentation of the methods below is in the .m file (DataAccess.m)
-(void)readWorkoutInfoFromDatabase;
-(void)readWorkoutSessionDataFromDatabase;
-(void)checkAndCreateDatabase;
-(BOOL)insertIntoDatabase:(WorkoutTracking *)workout;
@end

