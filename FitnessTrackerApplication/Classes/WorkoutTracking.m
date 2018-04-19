//
//  WorkoutTracking.m
//  FitnessTrackerApplication
//
//  Created by Xcode User on 2018-04-19.
//  Copyright © 2018 RADS. All rights reserved.
//

#import "WorkoutTracking.h"


@implementation WorkoutTracking
@synthesize workoutID, date, reps, weight;

-(id)initWithData:(NSString *)n reps:(NSString *)r weight:(NSString *)w {
    
    if(self = [super init]){
        
        [self setDate:n];
        [self setReps:r];
        [self setWeight:w];
        
    }
    return self;
    
}

@end

