//
//  AppDelegate+SQLCleaner.h
//  BOC
//
//  Created by huhao on 14-9-2.
//  Copyright (c) 2014年 胡皓. All rights reserved.
//

@class AppDelegate;
static char  kSQLCleanerCompleteKey;
static char  kSQLCleanerFailedKey;
typedef void(^SQLCompleteBlock) (NSInteger buttonIndex);
typedef void(^SQLFailedBlock) (NSInteger buttonIndex);
typedef void(^SQLExecuteBlock) (NSInteger buttonIndex);
@protocol SQLCleanerDelegate <NSObject>
@required
- (void)SQLCleanerComplete:(AppDelegate *)appDelegate forSQLCleanerSQL:(NSString *)sql;
- (void)SQLCleanerFailed:(AppDelegate *)appDelegate forSQLCleanerSQL:(NSString *)sql;
@end

#import "AppDelegate.h"
@interface AppDelegate (SQLCleaner)<SQLCleanerDelegate>
@property (strong ,nonatomic) id<SQLCleanerDelegate> theSQLCleanerDelegate;
-(void)appDBCleaner:(SQLExecuteBlock)bb cc:(SQLCompleteBlock)cc dd:(SQLFailedBlock)dd;
@end
