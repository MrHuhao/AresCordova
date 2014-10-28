//
//  AresAppFilterClean.m
//  BOC
//
//  Created by huhao on 14-9-16.
//  Copyright (c) 2014年 胡皓. All rights reserved.
//

#import "AresAppFilterClean.h"

@implementation AresAppFilterClean
-(void)filter{
    
}

-(void)doFilter:(NSString *)aurlParam inModel:(NSString *)model{
    NSString *urlParam = aurlParam;
    urlParam = [[urlParam URLEncodedString] URLEncodedString];
    NSString *strOfUrl = [[PCMobileBankGlobal sharedInstance] getServerUrl:urlParam];
    NSMutableURLRequest *theNSURLRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:strOfUrl]];
    [theNSURLRequest setTimeoutInterval:10.0f];
    AFHTTPRequestOperation *theAFHTTPRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:theNSURLRequest];
    [theAFHTTPRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"CLEAN"] isEqualToString:@"Y"]) {
             [AppDelegate appCleaner];
        }else{
            //do nothing
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //TODO..
    }];
    [theAFHTTPRequestOperation start];
}

@end
