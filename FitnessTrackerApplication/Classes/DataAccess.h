//
//  DataAccess.h
//  FitnessTrackerApplication
//
//  Created by Raj on 2018-04-06.
//  Copyright © 2018 RADS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataAccess : NSObject {
    NSString *databaseName;
    NSString *databasePath;
    NSMutableArray *users;
}

@property (strong, nonatomic) NSString *databaseName;
@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) NSMutableArray *users;
//-(instancetype)initWithDatabaseName:(NSString *)dbName;
-(void)readDataFromDatabase; //so that it can be used by other classes
-(BOOL)findUserFromDatabase:(NSString *) username; 

@end
