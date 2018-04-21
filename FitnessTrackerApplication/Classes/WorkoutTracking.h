//
//  WorkoutTracking.h
//  FitnessTrackerApplication
//
//  Created by Xcode User on 2018-04-19.
//  Copyright © 2018 RADS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkoutTracking : NSObject{
    
    NSString *date;
    NSString *reps;
    NSString *weight;
    NSString *wID;
    NSString *duration;
    NSString *sets;
}


@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *reps;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *wID;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *sets;


-(id)initWithData:(NSString *)d reps:(NSString *)r weight:(NSString *)w sets:(NSString*)s duration:(NSString *)du wID:(NSString *)i;

@end
