//
//  AppDelegate.m
//  FitnessTrackerApplication
//
//  Created by Xcode User on 2018-04-19.
//  Copyright © 2018 RADS. All rights reserved.
//

#import "AppDelegate.h"
#import <sqlite3.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize databaseName, databasePath, workouts, workoutInfo, workoutID;


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

-(void)readDataFromDatabase
{
    [self.workouts removeAllObjects];
    sqlite3 *database;

    if(sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK)
    {
        NSLog(@"Database opened");
        char *sqlStatement = "select * from 'session'";
      
        sqlite3_stmt *compiledStatement;
        
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
              
                WorkoutTracking *workout = [[WorkoutTracking alloc] initWithData:date reps:reps weight:weight sets:sets duration:duration wID:wID];
               
                [self.workouts addObject:workout];
            }
        }
        else{
          NSLog(@"SQLite not okay"); /////since you cant dynamically add variables to sql query, select all, then filter through session objects with foreach, and then an if to match with the work out id. You can add them to supporting class (workout tracking ) first by setting class variables then use them in statistics class
        }
        sqlite3_finalize(compiledStatement);
        
    }else{
        NSLog(@"Database didnt open");
    }
    sqlite3_close(database);
    
}

-(void)readWorkoutInfoFromDatabase
{
    [self.workoutInfo removeAllObjects];
    sqlite3 *database;
    
    if(sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK)
    {
        NSLog(@"Database opened");
        char *sqlStatement = "select * from 'workout'";
        
        sqlite3_stmt *compiledStatement;
        
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
               
            
                WorkoutInfo *info = [[WorkoutInfo alloc] initWithData:(NSString *)wID name:name videoCode:videoCode];
                
                [self.workoutInfo addObject:info];
      
            }
        }
        else{
            NSLog(@"SQLite not okay"); /////since you cant dynamically add variables to sql query, select all, then filter through session objects with foreach, and then an if to match with the work out id. You can add them to supporting class (workout tracking ) first by setting class variables then use them in statistics class
        }
        sqlite3_finalize(compiledStatement);
        
    }else{
        NSLog(@"Database didnt open");
    }
    sqlite3_close(database);
    
}
-(BOOL)insertIntoDatabase:(WorkoutTracking *)workout
{
    
    sqlite3 *database;
    BOOL returnCode = YES;
    
   
    if(sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK)
    {
        char *sqlStatement = "insert into session values(NULL, ?, ?, ?, ?, ?, ?)";
        sqlite3_stmt *compiledStatement;
        
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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.workoutID = 1;
    self.workouts = [[NSMutableArray alloc] init];
    self.workoutInfo = [[NSMutableArray alloc] init];
    self.databaseName = @"workoutdb.db";
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    
    self.databasePath = [documentsDir stringByAppendingPathComponent:self.databaseName];
    [self checkAndCreateDatabase];
    [self readDataFromDatabase];
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
