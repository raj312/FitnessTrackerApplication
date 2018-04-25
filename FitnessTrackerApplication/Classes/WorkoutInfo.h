//
//  WorkoutInfo.h
//  FitnessTrackerApplication
//
//  Created by Anthony Rella on 2018-04-19.
//  Copyright © 2018 RADS. All rights reserved.
//
//  Workout Info class is used to store workout info type data, to be used for select queries from workoutdb.db

#import <Foundation/Foundation.h>

@interface WorkoutInfo : NSObject
{
    
    NSString *workoutInfoID; //will hold the workoutinfoID from workout type
    NSString *name; //will hold the name of the workout type
    NSString *videoCode; //will hold the youtube video code from the workout type
   
}


@property (nonatomic, strong) NSString *workoutInfoID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *videoCode;

//documentation is below in the WorkoutTracking.m file
-(id)initWithData:(NSString *)wi name:(NSString *)n videoCode:(NSString *)vc;
@end
