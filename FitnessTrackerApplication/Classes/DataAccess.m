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

-(BOOL)insertIntoDatabase:(User *)user {
    sqlite3 *database;
    BOOL returnCode = YES;
    
    if(sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK) {
        char *sqlStatement = "Insert INTO users VALUES (NULL, ?, ?, ?, ?, ?, ?)";
        //this means there are placeholders and we will replace them with data
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            //replacing the question marks with proper values
            // 1 - second field in DB
            sqlite3_bind_text(compiledStatement, 1, [user.name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 2, [user.username UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 3, [user.password UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 4, [user.address UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 5, [user.gender UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 6, [user.dateOfBirth UTF8String], -1, SQLITE_TRANSIENT);
        }
        if(sqlite3_step(compiledStatement) != SQLITE_DONE) {
            NSLog(@"Error: %s", sqlite3_errmsg(database));
            returnCode = NO;
        }else {
            NSLog(@"Insert into row id = %lld", sqlite3_last_insert_rowid(database));
        }
        //clean up
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    return returnCode;
}
@end
