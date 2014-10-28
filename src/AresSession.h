//
//  BOCDGlobal.h
//  BOCDBank
//
//  Created by YK on 13-6-24.
//  Copyright (c) 2013年 P&C. All rights reserved.

#import <Foundation/Foundation.h>
#import "NSObject+Singleton.h"
#import "AresFstLogSession.h"
//@class AresFstLogSession;
@interface AresSession : NSObject
@property (strong , nonatomic ) AresFstLogSession *theAresFstLogSession;
@property (strong , nonatomic ) NSString *key;
@end
