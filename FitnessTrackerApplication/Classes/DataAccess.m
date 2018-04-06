//
//  DataAccess.m
//  FitnessTrackerApplication
//
//  Created by Raj on 2018-04-06.
//  Copyright © 2018 RADS. All rights reserved.
//

#import "DataAccess.h"
#import "sqlite3.h"

@implementation DataAccess
@synthesize databaseName, databasePath, users;

-(instancetype)init {
    self = [super init];
    if (self) {
        // Set the documents directory path to the documentsDirectory property.
        self.databaseName = @"FitnessInfo.db";
        //returns an array of documents paths
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        self.databasePath = [documentsDir stringByAppendingPathComponent:self.databaseName];
        
        // Copy the database file into the documents directory if necessary.
        [self checkAndCreateDatabase];
        //return YES;
    }
    return self;
}

-(void)checkAndCreateDatabase{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:self.databasePath];
    if (success){
        return;
    }
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseName];
    
    NSError *error;
    [fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:&error];
    
    // Check if any error occurred during copying and display it.
    if (error != nil) {
//        NSLog(@"%@", [error localizedDescription]);
        printf("Error connecting to db");
    }
}
/*
-(void)readDataFromDatabase {
    // clear out array at the start
    [self.users removeAllObjects];
    
    sqlite3 *database;
    //opens connection to database
    if(sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK){
        //defining a query
        char *sqlStatement = "SELECT * FROM users"; //not using @ since its a char
        
        sqlite3_stmt *compileStatement;
        //prepare the object -- -1 all data
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compileStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(compileStatement) == SQLITE_ROW) { //while there is a row returned
                char *n = (char *)sqlite3_column_text(compileStatement, 1); //1 - second column -- name
                NSString *name = [NSString stringWithUTF8String:n];
                
                char *e = (char *)sqlite3_column_text(compileStatement, 2); //1 - third column -- email
                NSString *email = [NSString stringWithUTF8String:e];
                
                char *f = (char *)sqlite3_column_text(compileStatement, 3); //1 - forth column -- food
                NSString *food = [NSString stringWithUTF8String:f];
                
                Data *data = [[Data alloc] initWithData:name theEmail:email theFood:food];
                
                [self.people addObject:data];
                
            }
        }
        
        //cleaning up - free up resources
        sqlite3_finalize(compileStatement);
    }
    sqlite3_close(database);
}
 */

-(BOOL)findUserFromDatabase:(NSString *) username{
    // clear out array at the start
    //[self.users removeAllObjects];
    NSString *uname = (NSString *)username;
    BOOL userExists = false;
    sqlite3 *database;
    //opens connection to database
    if(sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK){
        //defining a query
        const char *sqlStatement = [[NSString stringWithFormat:@"SELECT * FROM users where Username = '%@'", uname] UTF8String];
//        printf("%s", sqlStatement);
        sqlite3_stmt *compileStatement;
        //prepare the object -- -1 all data
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compileStatement, NULL) == SQLITE_OK) {
            if(sqlite3_step(compileStatement) == SQLITE_ROW) { //if there is a row returned
                userExists = true;
            }
        }
        //cleaning up - free up resources
        sqlite3_finalize(compileStatement);
    }
    sqlite3_close(database);
    return userExists;
}


@end
