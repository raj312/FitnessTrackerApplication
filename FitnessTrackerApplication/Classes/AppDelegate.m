//
//  AppDelegate.m
//  FitnessTrackerApplication
//
//  Created by Anthony Rella on 2018-04-19.
//  Copyright © 2018 RADS. All rights reserved.
//

#import "AppDelegate.h"
#import <sqlite3.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize databaseName, databasePath, workouts, workoutInfo, workoutID, path, photos; //getters and setters for these properties


//Checks to see if database currently exists in device. If not it will create a database in the Documents index of device
-(void)checkAndCreateDatabase
{
    
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    success = [fileManager fileExistsAtPath:self.databasePath];
    
    if(success) return;
    
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseName];
    
    [fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:nil];
    
    return;
}

//Selects all data from session table in workoutdb.db. Stores the data in workouts array to be used throughout application.
-(void)readWorkoutSessionDataFromDatabase
{
    //initially removes objects from workouts array
    [self.workouts removeAllObjects];
    sqlite3 *database;

    //request to open database
    if(sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK)
    {
        NSLog(@"Database opened");
        char *sqlStatement = "select * from 'session'";
      
        sqlite3_stmt *compiledStatement;
        
        //performs the select. Enters the data, reps, weight, sets, duration and workoutID data into string variables
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                char *d = sqlite3_column_text(compiledStatement, 1);
                NSString *date = [NSString stringWithUTF8String:(char *)d];
                char *r = sqlite3_column_text(compiledStatement, 2);
                NSString *reps = [NSString stringWithUTF8String:(char *)r];
                char *w = sqlite3_column_text(compiledStatement, 3);
                NSString *weight = [NSString stringWithUTF8String:(char *)w];
                char *s = sqlite3_column_text(compiledStatement, 4);
                NSString *sets = [NSString stringWithUTF8String:(char *)s];
                char *du = sqlite3_column_text(compiledStatement, 5);
                NSString *duration = [NSString stringWithUTF8String:(char *)du];
                char *i = sqlite3_column_text(compiledStatement, 6);
                NSString *wID = [NSString stringWithUTF8String:(char *)i];
              
                //initializes WorkoutTracking class with data received from select query
                WorkoutTracking *workout = [[WorkoutTracking alloc] initWithData:date reps:reps weight:weight sets:sets duration:duration wID:wID];
               
                //AppDelegate stores workout session array of objects into workouts array
                [self.workouts addObject:workout];
            }
        }
        else
        {
          NSLog(@"Paramaters for query contain errors");
        }
        
        sqlite3_finalize(compiledStatement);
        
    }
    else
    {
        NSLog(@"Database didnt open");
    }
    
    sqlite3_close(database);
}

//Selects all data from workout table in workoutdb.db. Stores the data in workoutinfo array to be used throughout application.
-(void)readWorkoutInfoFromDatabase
{
    //initially removes objects from workoutInfo array
    [self.workoutInfo removeAllObjects];
    sqlite3 *database;
    
     //request to open database
    if(sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK)
    {
        NSLog(@"Database opened");
        char *sqlStatement = "select * from 'workout'";
        
        sqlite3_stmt *compiledStatement;
        
        //performs the select. Enters the workoutID, name and videoCode into string variables
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                char *w = sqlite3_column_text(compiledStatement, 0);
                NSString *wID = [NSString stringWithUTF8String:(char *)w];
                char *n = sqlite3_column_text(compiledStatement, 1);
                NSString *name = [NSString stringWithUTF8String:(char *)n];
                char *v = sqlite3_column_text(compiledStatement, 2);
                NSString *videoCode = [NSString stringWithUTF8String:(char *)v];
               
                //initializes WorkoutInfo class with data received from select query
                WorkoutInfo *info = [[WorkoutInfo alloc] initWithData:(NSString *)wID name:name videoCode:videoCode];
                
                //AppDelegate stores workout session array of objects into workouts array
                [self.workoutInfo addObject:info];
      
            }
        }
        else
        {
            NSLog(@"Paramaters for query contain errors");
        }
        sqlite3_finalize(compiledStatement);
        
    }else
    {
        NSLog(@"Database didnt open");
    }
    sqlite3_close(database);
    
}

//Inserts data entered from workout session tracking into workoutdb.db database
-(BOOL)insertIntoDatabase:(WorkoutTracking *)workout
{
    
    sqlite3 *database;
    BOOL returnCode = YES;
    
    //request to open database
    if(sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK)
    {
        char *sqlStatement = "insert into session values(NULL, ?, ?, ?, ?, ?, ?)";
        sqlite3_stmt *compiledStatement;
        
        //performs the insert. Enters date, reps, weight, sets, duration and workoutID into workoutdb.db database
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text(compiledStatement, 1, [workout.date UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 2, [workout.reps UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 3, [workout.weight UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 4, [workout.sets UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 5, [workout.duration UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 6, [workout.wID UTF8String], -1, SQLITE_TRANSIENT);
           
        }
        
        if(sqlite3_step(compiledStatement) != SQLITE_DONE)
        {
            NSLog(@"Error: %s", sqlite3_errmsg(database));
            returnCode = NO;
        }
        else
        {
            
            NSLog(@"Insert into row id = %lld", sqlite3_last_insert_rowid(database));
        }

        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    return returnCode;
}

//runs after application finishes launching. Will set the database name and path, as well as initialize class variables.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //default until changed by selection from MyWorkoutsController. This value is used to display specific workout info on the TrackController
    self.workoutID = 2;
    self.workouts = [[NSMutableArray alloc] init];
    self.workoutInfo = [[NSMutableArray alloc] init];
    self.databaseName = @"workoutdb.db";
    
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    
    
    self.databasePath = [documentsDir stringByAppendingPathComponent:self.databaseName];
    
    //runs these three methods to initialize workoutdb.db database, and store workoutdb.db database information into workouts and workoutinfo class variables
    [self checkAndCreateDatabase];
    [self readWorkoutSessionDataFromDatabase];
    [self readWorkoutInfoFromDatabase];
    
    NSLog(self.databasePath);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
