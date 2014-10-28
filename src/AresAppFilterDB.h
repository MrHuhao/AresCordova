//
//  AresAppFilterDB.h
//  BOC
//
//  Created by huhao on 14-9-15.
//  Copyright (c) 2014年 胡皓. All rights reserved.
//

#import "AresAppFilterBase.h"
#import "NSObject+Singleton.h"
#import "IISerialAsyncOperationQueue.h"
@interface AresAppFilterDB : AresAppFilterBase
@property (strong , nonatomic ) IISerialAsyncOperationQueue *queue;
@end
