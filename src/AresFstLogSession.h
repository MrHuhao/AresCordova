//
//  AresFstLogSession.h
//  BOC
//
//  Created by huhao on 12-8-18.
//  Copyright (c) 2012年 胡皓. All rights reserved.

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface AresFstLogSession : JSONModel
@property (strong , nonatomic) NSString *userId;
@property (strong , nonatomic) NSString *orgId;
@property (strong , nonatomic) NSString *orgName;
@end
