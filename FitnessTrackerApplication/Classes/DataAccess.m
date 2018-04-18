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

-(NSString *)readDataAndAuthenticateUser:(NSString *)uname password:(NSString *)pass {
    // clear out array at the start
    //[self.users removeAllObjects];
    //BOOL userIsValid = false;
    NSString *errorMsg = @"";
    sqlite3 *database;
    //opens connection to database
    if(sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK){
        //defining a query
//        char *sqlStatement = "SELECT * FROM users WHERE "; //not using @ since its a char
        const char *sqlStatement = [[NSString stringWithFormat:@"SELECT * FROM users where Username = '%@' AND Password = '%@'", uname, pass] UTF8String];
        printf("%s", sqlStatement);
        sqlite3_stmt *compileStatement;
        //prepare the object -- -1 all data
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compileStatement, NULL) == SQLITE_OK) {
            if(sqlite3_step(compileStatement) == SQLITE_ROW) { //if there is a row returned
                //user is valid
            }else {
                NSString *msg = @"Invalid Login. Try again";
                NSString *concat = [NSString stringWithFormat:@"%@%@", errorMsg, msg];
                errorMsg = concat;
            }
        }
        //cleaning up - free up resources
        sqlite3_finalize(compileStatement);
    }
    sqlite3_close(database);
    return errorMsg;
}

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
                char *u = (char *)sqlite3_column_text(compileStatement, 2); //2 - username
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
