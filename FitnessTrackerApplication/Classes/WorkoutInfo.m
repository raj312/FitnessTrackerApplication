//
//  WorkoutInfo.m
//  FitnessTrackerApplication
//
//  Created by Xcode User on 2018-04-19.
//  Copyright © 2018 RADS. All rights reserved.
//

#import "WorkoutInfo.h"

@implementation WorkoutInfo

@synthesize workoutInfoID, name, videoCode;

-(id)initWithData:(NSString *)wi name:(NSString *)n videoCode:(NSString *)vc{
    
    if(self = [super init]){
        
        [self setWorkoutInfoID:wi];
        [self setName:n];
        [self setVideoCode:vc];
       
    }
    return self;
    
}
@end
