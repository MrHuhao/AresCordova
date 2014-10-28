//
//  AresAppFilterDB.m
//  BOC
//
//  Created by huhao on 14-9-15.
//  Copyright (c) 2014年 胡皓. All rights reserved.
//

#import "AresAppFilterDB.h"
#import "IISerialAsyncOperationQueue.h"
#import "AFNetworkReachabilityManager.h"
@interface AresAppFilterDB()
@end

@implementation AresAppFilterDB
static int filterNum;
-(void)filter{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if ([AFNetworkReachabilityManager sharedManager].isReachable) {
                [AppDelegate showAppWaitView];
                filterNum = 3;
                [self doFilter:__urlParam1__ inModel:__urlfun0__];
                [self doFilter:__urlParam1__ inModel:__urlfun1__];
                [self doFilter:__urlParam1__ inModel:__urlfun2__];
            }else {
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [app  showNotifitionView];
            }
    }];
}

-(void)doFilter:(NSString *)aurlParam inModel:(NSString *)model{
    NSString *urlParam = aurlParam;
    urlParam = [[urlParam URLEncodedString] URLEncodedString];
    NSString *strOfUrl = [[PCMobileBankGlobal sharedInstance] getServerUrl:urlParam];
    NSMutableURLRequest *theNSURLRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:strOfUrl]];
    [theNSURLRequest setTimeoutInterval:10.0f];
    AFHTTPRequestOperation *theAFHTTPRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:theNSURLRequest];
    [theAFHTTPRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self saveTolocaltion:[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding] inModel:model];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self complete];
    }];
    [theAFHTTPRequestOperation start];
}

-(void)saveTolocaltion:(NSString *)data inModel:(NSString *)model{
    NSDictionary *dictOfresponse = [[CJSONDeserializer deserializer] deserialize:[data dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    [self saveOrUpdate:dictOfresponse[@"LIST"]  inModel:model];
}

-(void)saveOrUpdate:(id)data inModel:(NSString *)model{
    if(![[AresAppFilterDB singleton] queue]){
        [[AresAppFilterDB singleton] setQueue: [IISerialAsyncOperationQueue new]];
    }
    [[[AresAppFilterDB singleton] queue] addOperation:^(id<IISerialAsyncOperation> operation) {
        [[[ZIMORMManagerImp alloc] init] clearAll:nil inModel:model];
        [[[ZIMORMManagerImp alloc] init] save:data inModel:model];
        NSLog(@"[DATABASE]:%@",@"强制更新完成");
        [operation complete];
        [self complete];
    }];
}

-(void)complete{
    filterNum = filterNum - 1;
    if (filterNum!=0) {
        //do nothing
    }else{
        [self go];
    }
}

-(void)go{
    [AppDelegate hideAppWaitView];
}
@end
