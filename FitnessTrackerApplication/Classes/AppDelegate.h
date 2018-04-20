//
//  AppDelegate.h
//  Assignment1.Anthony.Rella
//
//  Created by Xcode User on 2018-04-16.
//  Copyright © 2018 Xcode User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutTracking.h"
#import "WorkoutInfo.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    // step 5 - define variables for database location & array for data in db
    NSString *databaseName;
    NSString *databasePath;
    NSMutableArray *workouts;
    NSInteger workoutID;
    NSMutableArray *workoutInfo;
}

// step 5b - define getters and setters for vars, move on to m file
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *databaseName;
@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) NSMutableArray *workouts;
@property (strong, nonatomic) NSMutableArray *workoutInfo;
@property NSInteger workoutID;

-(void)readWorkoutInfoFromDatabase;
-(void)readDataFromDatabase;
-(void)checkAndCreateDatabase;
-(BOOL)insertIntoDatabase:(WorkoutTracking *)workout;
@end

