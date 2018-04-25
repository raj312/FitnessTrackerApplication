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
    NSString *databaseName;
    NSString *databasePath;
    NSMutableArray *workouts;
    NSInteger workoutID;
    NSMutableArray *workoutInfo;
    NSMutableString *photos;
    NSMutableString *path;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *databaseName;
@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) NSMutableArray *workouts;
@property (strong, nonatomic) NSMutableArray *workoutInfo;
@property NSInteger workoutID;
@property (strong, nonatomic) NSMutableString *photos;
@property (strong, nonatomic) NSMutableString *path;

-(void)readWorkoutInfoFromDatabase;
-(void)readDataFromDatabase;
-(void)checkAndCreateDatabase;
-(BOOL)insertIntoDatabase:(WorkoutTracking *)workout;
@end

