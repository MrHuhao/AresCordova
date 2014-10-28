//
//  AppDelegate+SQLCleaner.m
//  BOC
//
//  Created by huhao on 14-9-2.
//  Copyright (c) 2014年 胡皓. All rights reserved.
//
#import "NSString+URLEncoding.h"
#import "UIAlertView+Blocks.h"
#import "FBDMManager.h"
#import "AFNetworking.h"
#import <objc/runtime.h>
#import "AppDelegate+SQLCleaner.h"

@implementation AppDelegate (SQLCleaner)

-(void)appDBCleaner:(SQLExecuteBlock)bb cc:(SQLCompleteBlock)cc dd:(SQLFailedBlock)dd{
    if ( self.theSQLCleanerDelegate==nil) {
        self.theSQLCleanerDelegate = self;
    }
    if (cc&&dd) {
        objc_removeAssociatedObjects(self);
        objc_setAssociatedObject(self, &kSQLCleanerCompleteKey, cc, OBJC_ASSOCIATION_COPY);
        objc_setAssociatedObject(self, &kSQLCleanerFailedKey, dd, OBJC_ASSOCIATION_COPY);
    }
    bb(0);
    [self doInterface:@"" aurlParam:@"" inModel:@""];//TODO
}

-(void )doInterface:(NSString *)aurl aurlParam :(NSString *)aurlParam inModel:(NSString *)model{
    NSString *urlParam =  aurlParam;
    urlParam = [[urlParam URLEncodedString] URLEncodedString];
    NSString *strOfUrl = [NSString stringWithFormat:aurl ,urlParam];
    NSMutableURLRequest *theNSURLRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:strOfUrl]];
    [theNSURLRequest setTimeoutInterval:10];
    AFHTTPRequestOperation *theAFHTTPRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:theNSURLRequest];
    [theAFHTTPRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIAlertView showWithTitle:@"问题提示" message:@"本地数据过期,是否立即清除" cancelButtonTitle:@"" otherButtonTitles:@[] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==0) {
                if ([self executeDeleteSQL:@[]]) {            //清除完毕
                    if (self.theSQLCleanerDelegate) {
                        [self.theSQLCleanerDelegate SQLCleanerComplete:self forSQLCleanerSQL:@""];
                    }
                }else{
                    if (self.theSQLCleanerDelegate) {            //清除失败
                        [self.theSQLCleanerDelegate SQLCleanerFailed:self forSQLCleanerSQL:@""];
                    }
                    
                }
            }else{// 用户不清除
                  [self.theSQLCleanerDelegate SQLCleanerFailed:self forSQLCleanerSQL:@""];
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.theSQLCleanerDelegate) {            //清除失败
            [self.theSQLCleanerDelegate SQLCleanerFailed:self forSQLCleanerSQL:@""];
        }//没有网络（接口）
    }];
    [theAFHTTPRequestOperation start];
}

-(BOOL)executeDeleteSQL:(NSArray *)model{
    NSArray *result3  = [[[FBDMManager alloc]init] query:@"select distinct * from CunDaiBiHome" withArgumentsInArray:nil];
    if (result3&&[result3 count]!=0) {
        return YES;
    }
    return NO;
}

- (void)SQLCleanerComplete:(AppDelegate *)appDelegate forSQLCleanerSQL:(NSString *)sql{
    SQLCompleteBlock block = objc_getAssociatedObject(self, &kSQLCleanerCompleteKey);
    if (block) {
        block(0);
    }
}

- (void)SQLCleanerFailed:(AppDelegate *)appDelegate forSQLCleanerSQL:(NSString *)sql{
    SQLCompleteBlock block = objc_getAssociatedObject(self, &kSQLCleanerFailedKey);
    if (block) {
        block(0);
    }
}
@end
