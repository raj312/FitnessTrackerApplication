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

@synthesize databaseName, databasePath, workouts;


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
              
                WorkoutTracking *workout = [[WorkoutTracking alloc] initWithData:date reps:reps weight:weight];
               
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
-(BOOL)insertIntoDatabase:(WorkoutTracking *)workout
{
    // define object to interact with database
    sqlite3 *database;
    BOOL returnCode = YES;
    
    // step 17c - open a connection to db
    if(sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK)
    {
        // step 17d - define query for db
        // ?'s are placeholders for values
        // null represents id column to auto increment
        char *sqlStatement = "insert into users values(NULL, ?, ?, ?, ?, ?, ?, ?, ?)";
        sqlite3_stmt *compiledStatement;
        
        // step 17e - prepare object to handle datatransfer
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // step 17f - attach name, email, food in place of ?'s
//            sqlite3_bind_text(compiledStatement, 1, [user.name UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(compiledStatement, 2, [user.address UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(compiledStatement, 3, [user.phone UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(compiledStatement, 4, [user.email UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(compiledStatement, 5, [user.age UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(compiledStatement, 6, [user.gender UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(compiledStatement, 7, [user.birthdate UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(compiledStatement, 8, [user.avatar UTF8String], -1, SQLITE_TRANSIENT);
//
            
        }
        
        // step 17g - execute query, check for errors
        if(sqlite3_step(compiledStatement) != SQLITE_DONE)
        {
            NSLog(@"Error: %s", sqlite3_errmsg(database));
            returnCode = NO;
        }
        else
        {
            // print out success by printing out new row id number
            NSLog(@"Insert into row id = %lld", sqlite3_last_insert_rowid(database));
        }
        // step 17h - clean up memory allocations
        sqlite3_finalize(compiledStatement);
    }
    
    // step 17i - close connection to db
    // move on to ViewController.m - create addPerson event handler
    sqlite3_close(database);
    return returnCode;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.workouts = [[NSMutableArray alloc] init];
    self.databaseName = @"workoutdb.db";
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    
    self.databasePath = [documentsDir stringByAppendingPathComponent:self.databaseName];
    [self checkAndCreateDatabase];
    [self readDataFromDatabase];
    
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
