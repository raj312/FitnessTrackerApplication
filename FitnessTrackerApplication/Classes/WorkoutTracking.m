//
//  WorkoutTracking.m
//  FitnessTrackerApplication
//
//  Created by Xcode User on 2018-04-19.
//  Copyright © 2018 RADS. All rights reserved.
//

#import "WorkoutTracking.h"


@implementation WorkoutTracking
@synthesize reps, wID, weight, sets, duration, date;

-(id)initWithData:(NSString *)d reps:(NSString *)r weight:(NSString *)w sets:(NSString *)s duration:(NSString *)du wID:(NSString *)i {
    
    if(self = [super init]){
        
        [self setDate:d];
        [self setReps:r];
        [self setWeight:w];
        [self setWID:i];
        [self setDuration:du];
        [self setSets:s];
        
    }
    return self;
    
}

@end

