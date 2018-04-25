//
//  DataAccess.m
//  FitnessTrackerApplication
//
//  Created by Raj Patel on 2018-04-06.
//  Copyright © 2018 RADS. All rights reserved.
//

#import "DataAccess.h"
#import "sqlite3.h"
#import <sqlite3.h>

@implementation DataAccess
@synthesize databaseName, databasePath, users, imgDatabaseName, imgDatabasePath, photos; //getters and setters for these properties

//Class constructor
-(instancetype)init {
    self = [super init];
    if (self) {
        self.photos = [[NSMutableArray alloc] init];
        // Set the documents directory path to the documentsDirectory property.
        self.databaseName = @"FitnessInfo.db";
        self.imgDatabaseName = @"gallery.db";
        //returns an array of documents paths
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        self.databasePath = [documentsDir stringByAppendingPathComponent:self.databaseName];
        
        
        NSArray *imgDocumentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *imgDocumentsDir = [imgDocumentPaths objectAtIndex:0];
        self.imgDatabasePath = [imgDocumentsDir stringByAppendingPathComponent:self.imgDatabaseName];
        
        // Copy the database file into the documents directory if it doesnt exist already
        [self checkAndCreateDatabase];
        [self checkAndCreateImgDatabase];
    }
    return self;
}

//check if database file exists and if not, create it
-(void)checkAndCreateDatabase{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //function returns true if file exists
    success = [fileManager fileExistsAtPath:self.databasePath];
    if (success){
        return;
    }
    //if file does not exist, create it.
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseName];
    //handle an error if copying the database failed
    NSError *error;
    [fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:&error];
    
    // Check if any error occurred during copying and display it.
    if (error != nil) {
//        NSLog(@"%@", [error localizedDescription]);
        printf("Error connecting to db");
    }
}



// check the database if the username and password match and if yes, authenticate the user
-(NSString *)readDataAndAuthenticateUser:(NSString *)uname password:(NSString *)pass {
    NSString *errorMsg = @"";
    sqlite3 *database;
    //opens connection to database
    if(sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK){
        //defining a query
        const char *sqlStatement = [[NSString stringWithFormat:@"SELECT * FROM users where Username = '%@' AND Password = '%@'", uname, pass] UTF8String];
        //printf("%s", sqlStatement);
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
    //close the connection
    sqlite3_close(database);
    return errorMsg;
}

//checks if user exists in the database. Used to verify the username is unique
-(BOOL)findUserFromDatabase:(NSString *) username{
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
            if(sqlite3_step(compileStatement) == SQLITE_ROW) { //if there is a row returned, user exists
                //char *u = (char *)sqlite3_column_text(compileStatement, 2); //2 - username
                // set userExists to true
                userExists = true;
            }
        }
        //cleaning up - free up resources
        sqlite3_finalize(compileStatement);
    }
    sqlite3_close(database);
    return userExists;
}

// Add new user to the database - takes in a user object and saves all its info in the users table in db
-(BOOL)insertIntoDatabase:(User *)user {
    sqlite3 *database;
    //will return a boolean depending on whether the "insert" passes or fails
    BOOL returnCode = YES;
    //open the connection
    if(sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK) {
        // ? means there are placeholders and we will replace them with data
        char *sqlStatement = "Insert INTO users VALUES (NULL, ?, ?, ?, ?, ?, ?)";
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            //replacing the question marks with proper values
            // in the DB, 1 - second field, 2 - 3rd field etc.
            //get all user values and pass them as parameters to the sql query
            sqlite3_bind_text(compiledStatement, 1, [user.name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 2, [user.username UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 3, [user.password UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 4, [user.address UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 5, [user.gender UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 6, [user.dateOfBirth UTF8String], -1, SQLITE_TRANSIENT);
        }
        //if insert fails, return NO (insert failed)
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

-(void)checkAndCreateImgDatabase
{
    // step 8 create method as follows
    
    // first step is to see if the file already exists at ~/Documents/MyDatabase.db
    // if it exists, do nothing and return
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    success = [fileManager fileExistsAtPath:self.imgDatabasePath];
    NSLog(self.imgDatabasePath);
    if(success) return;
    
    // if it doesn't (meaning its a first time load) find location of
    // MyDatabase.db in app file and save the path to it
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.imgDatabaseName];
    
    // copy file MyDatabase.db from app file into phone at ~/Documents/MyDatabase.db
    [fileManager copyItemAtPath:databasePathFromApp toPath:self.imgDatabasePath error:nil];
    NSLog(self.imgDatabasePath);
    // return to didFinishLaunching (don't forget to call this method there)
    return;
}

-(BOOL)insertIntoImgDatabase:(NSString *)photos
{
 

    // define object to interact with database
    sqlite3 *database;
    BOOL returnCode = YES;
    
    // step 17c - open a connection to db
    if(sqlite3_open([self.imgDatabasePath UTF8String], &database) == SQLITE_OK)
    {
        // step 17d - define query for db
        // ?'s are placeholders for values
        // null represents id column to auto increment
        char *sqlStatement = "insert into photos values(NULL, ?)";
        sqlite3_stmt *compiledStatement;
        
        // step 17e - prepare object to handle datatransfer
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // step 17f - attach name, email, food in place of ?'s
            sqlite3_bind_text(compiledStatement, 1, [photos UTF8String], -1, SQLITE_TRANSIENT);
            
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

-(void)readDataFromImgDatabase
{
       self.photos = [[NSMutableArray alloc] init];
    // now we will retrieve data from database
    // step 9 - empty people array
    [self.photos removeAllObjects];
    
    // step 9c - define sqlite3 object to interact with db
    sqlite3 *database;
    
    // step 9d - open connection to db file - this is C code
    if(sqlite3_open([self.imgDatabasePath UTF8String], &database) == SQLITE_OK)
    {
        NSLog(@"open database");
        // step 9e - setup query - entries is the table name you created in step 0
        char *sqlStatement = "select * from photos";
        sqlite3_stmt *compiledStatement;
        
        // step 9f - setup object that will handle data transfer
        if(sqlite3_prepare_v2(database,sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            NSLog(@"query worked");
            // step 9g - loop through row by row to extract dat
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                // step 9h - extract columns data, convert from char* to NSString
                // col 0 - id, col 1 = name, col 2 = email, col 3 = food
                char *p = sqlite3_column_text(compiledStatement, 1);
                NSString *path = [NSString stringWithUTF8String:(char *)p];
                
                // step 9i - save to data object and add to arrays
                [self.photos addObject:path];
            }
        }
        // step 9j - clean up
        sqlite3_finalize(compiledStatement);
        
    }
    // step 9k - close connection
    // move on to ViewController.h
    sqlite3_close(database);
    
}

@end
