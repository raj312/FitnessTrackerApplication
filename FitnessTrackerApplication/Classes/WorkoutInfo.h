//
//  WorkoutInfo.h
//  FitnessTrackerApplication
//
//  Created by Xcode User on 2018-04-19.
//  Copyright © 2018 RADS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkoutInfo : NSObject
{
    
    NSString *workoutInfoID;
    NSString *name;
    NSString *videoCode;
   
}


@property (nonatomic, strong) NSString *workoutInfoID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *videoCode;


-(id)initWithData:(NSString *)wi name:(NSString *)n videoCode:(NSString *)vc;
@end
