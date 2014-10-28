//
//  NativeNet.h
//  BOC
//
//  Created by huhao on 12-8-19.
//  Copyright (c) 2012年 胡皓. All rights reserved.
//  描述 ：这是一个专门用于缓存数据的插件,拥有强制刷新，队列查询，晴空缓存等功能

#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"
#import "JSQSystemSoundPlayer.h"
#define showShake() AudioServicesPlaySystemSound(1007);AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
#define showVoice() [[JSQSystemSoundPlayer sharedPlayer] playAlertSoundWithName:@"Funk" extension:kJSQSystemSoundTypeAIFF]
#define CDVPluginResult_OK(resulstFinal)  [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"STATUS":@"1",@"MSG":@"AAAAAAA",@"LIST":resulstFinal}]
#define CDVPluginResult_Failed()    [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"STATUS":@"0",@"MSG":@"查无此数据",@"LIST":@""}]

#define deserializeAsArray(_jsonString_) [[CJSONDeserializer deserializer]deserializeAsArray:[_jsonString_ dataUsingEncoding:NSUTF8StringEncoding] error:nil]
#define deserializeAsDictionary(_jsonString_) [[CJSONDeserializer deserializer]deserializeAsDictionary:[_jsonString_ dataUsingEncoding:NSUTF8StringEncoding] error:nil]
#define serializeDictionary(_resulstFinal_) [[NSString alloc]initWithData:[[CJSONSerializer serializer] serializeDictionary:_resulstFinal_ error:nil] encoding:NSUTF8StringEncoding]);
#define serializeObject(_resulstFinal_) [[NSString alloc]initWithData:[[CJSONSerializer serializer] serializeObject:_resulstFinal_ error:nil] encoding:NSUTF8StringEncoding]

#import "JSONModel.h"

#import "CDVPlugin.h"
#import "ProtocolNativeNet.h"
@protocol ProtocolNativeNetDO <NSObject>
-(IBAction)aresNetkResultSetSuccess:(NSNotification *)notification;
-(IBAction)aresNetkResultSetFailed:(NSNotification *)notification;
@end

@protocol ProtocolNativeNetDODataSource <NSObject>
-(NSArray *)nativeNetDODataSource:(id)nativeNetDO tableModel:(NSString *)tableModel;
-(NSInteger )nativeNetDODataSource:(id)nativeNetDO numberOftableModel:(NSInteger)numberOftableModel;
@end

@interface NativeNet : CDVPlugin<ProtocolNativeNet>
-(void)getData:(CDVInvokedUrlCommand*)commend;
-(void)callBack:(CDVPluginResult *)result callbackId:(NSString *)callbackId;
@end


#define kfun @"fun"
#define kprarm @"params"
#define kcode @"repcde"
@class AresNetOnlyLoadIfNotCachedModel;
@interface NativeNetDO:NSObject<ProtocolNativeNetDO,ProtocolNativeNetDODataSource>
{
}
@property (nonatomic, strong) id<ProtocolNativeNetDODataSource> dataSource;
@property (nonatomic, strong) NSString *htmlInterface;

@property (nonatomic, strong) NativeNet *callbackId;
@property (nonatomic, strong) NSDictionary *arguments ;
@property (nonatomic, strong) NSDictionary *predicate;
@property (nonatomic, strong) NSString * overwrite;
@property (nonatomic, strong) NSArray *order;
@property (nonatomic, strong) CDVInvokedUrlCommand *command;
@property (nonatomic, strong) NativeNet *delegate;
@property (nonatomic, strong) NSMutableArray *ResultSet;
-(void)didStart;
-(void)didEnd:(id)resulstFinal;
-(NSDictionary *)pingHTML:(NSArray *)aOrder;
#pragma market - 
-(NSMutableArray *)sort:(NSMutableArray *)arr atIndex:(NSInteger)index isDes:(NSString *)des;
id stringNotNull(id mm);
NSString* HTMLStringTime (NSString *strTimer);
@end