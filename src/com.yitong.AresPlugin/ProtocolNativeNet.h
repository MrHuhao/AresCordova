//
//  ProtocolNativeNet.h
//  BOC
//
//  Created by huhao on 14-8-27.
//  Copyright (c) 2014年 胡皓. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProtocolNativeNet <NSObject>
#define argumentsRequire(optional,CRNDAT) [self.arguments[kprarm] addObject:@{@"key":@"userId",@"value":@"developer"}];[self.arguments[kprarm] addObject:@{@"key":@"date",@"value":CRNDAT}];
@end

@protocol  Depacketize <NSObject>
#define _table_ @"_table_"
#define _home_ @"_home_"
#define _bocopRetLagbalChg_ @"_bocopRetLagbalChg_"
#define _bocopRetLagbalChgPub_ @"_bocopRetLagbalChgPub_"
#define _bocopReportType_ @"_bocopReportType_"
@end