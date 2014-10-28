//
//  AresFstLogSession.m
//  BOC
//
//  Created by huhao on 12-8-18.
//  Copyright (c) 2012年 胡皓. All rights reserved.

#import "AresFstLogSession.h"

@implementation AresFstLogSession
-(void)setUserId:(NSString *)userId{
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:AresGlobalDomain];
    _userId = userId;
}

-(void)setOrgId:(NSString *)orgId{
    _orgId = orgId;
}

-(void)setOrgName:(NSString *)orgName{
    _orgName = orgName;
}
@end
