//
//  WorkoutTracking.h
//  FitnessTrackerApplication
//
//  Created by Anthony Rella on 2018-04-19.
//  Copyright © 2018 RADS. All rights reserved.
//
//  Workout Tracking class is used to store workout session data in to be used with select and insert queries into workoutdb.db. 

#import <Foundation/Foundation.h>

@interface WorkoutTracking : NSObject{
    
    NSString *date; //will hold the date of tracked workout
    NSString *reps; //will hold the number of repitions for tracked workout
    NSString *weight; //will hold the weight of the tracked workout
    NSString *wID; //will hold the workoutID of the tracked workout
    NSString *duration; //will hold the duration of the tracked workout
    NSString *sets; //will hold the number of sets of the tracked workout
}


@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *reps;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *wID;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *sets;

//documentation is below in the WorkoutTracking.m file
-(id)initWithData:(NSString *)d reps:(NSString *)r weight:(NSString *)w sets:(NSString*)s duration:(NSString *)du wID:(NSString *)i;

@end
