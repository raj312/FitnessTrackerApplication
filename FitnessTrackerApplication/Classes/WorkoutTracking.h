//
//  WorkoutTracking.h
//  FitnessTrackerApplication
//
//  Created by Xcode User on 2018-04-19.
//  Copyright © 2018 RADS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkoutTracking : NSObject{
    
      NSInteger *workoutID;
      NSString *date;
    NSString *reps;
    NSString *weight;
}

@property NSInteger *workoutID;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *reps;
@property (nonatomic, strong) NSString *weight;

-(id)initWithData:(NSString *)n reps:(NSString *)r weight:(NSString *)w;

@end
