//
//  NativeNet.m
//  BOC
//
//  Created by huhao on 12-8-19.
//  Copyright (c) 2012年 胡皓. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "NativeNet.h"
#import "AresNetOnlyLoadIfNotCachedModel.h"

#import "NSObject+Singleton.h"


/*
 @ data ={"fun":"bocopRetApDay","prarm":[{"key":"userId","value":"ceshi0001"}]};
 */
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface NativeNetDO()<ProtocolNativeNetDO>
{
}
-(id)initWithCommend:(CDVInvokedUrlCommand *)command delegate:(id)delegate;
-(BOOL)campare:(NativeNetDO *)aNativeNetDO;
-(void)start;
@end

@implementation NativeNetDO
@synthesize callbackId = _callbackId;
@synthesize arguments = _arguments;
@synthesize predicate = _predicate;
@synthesize overwrite = _overwrite;
@synthesize order = _order;
-(id)initWithCommend:(CDVInvokedUrlCommand *)command delegate:(id)delegate withHtmlInterface:(NSString *)htmlInterface{
    self = [super init];
    if (self) {
        _command = command;
        _delegate = delegate;
        _htmlInterface = htmlInterface;
    }
    return self;
}
-(id)initWithCommend:(CDVInvokedUrlCommand *)command delegate:(id)delegate{
    self = [super init];
    if (self) {
        _command = command;
        _delegate = delegate;
    }
    return self;
}

-(BOOL)campare:(NativeNetDO *)aNativeNetDO{
    NSString *lastCommand =[[NSString alloc]initWithData: [[CJSONSerializer serializer] serializeArray:[_command arguments] error:nil] encoding:NSUTF8StringEncoding];
    NSString *thisCommand =[[NSString alloc]initWithData: [[CJSONSerializer serializer] serializeArray:[_command arguments] error:nil] encoding:NSUTF8StringEncoding];
    if ([thisCommand isEqualToString:lastCommand]) {
        NSLog(@"[警告] 建议取消请求，让用户休息一会(%@)",[_command arguments][0][0][0][kfun]);
        return YES;
    }
    return NO;
}

-(void)show{
    [AppDelegate showAppWaitView];
}

-(void)start{
    [self willStart];
    [self didStart];
}

-(void)willStart{
    [self performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aresNetkResultSetSuccess:) name:AresNetOnlyLoadIfNotCachedModelResultSetSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aresNetkResultSetFailed:) name:AresNetOnlyLoadIfNotCachedModelSetFailed object:nil];
    _ResultSet = [[NSMutableArray alloc] init];//没次掉插件清空结果集
}

-(id)pingHTML:(NSArray *)aOrder{
    NSArray *resultOfHeaderTable  = [[[FBDMManager alloc] init] query:@"select distinct * from ReportHeadTable  where HEADLIST = ?" withArgumentsInArray:@[self.predicate[@"CODE"]]];
    id row = nil;
    if (resultOfHeaderTable&&![resultOfHeaderTable count]<1) {
        row = resultOfHeaderTable[0];
    }
    NSDictionary *returnResult  = nil;
    if ([@"deposit" isEqualToString:row[@"DISPLAY"]]) {
      NSArray *resultOfHeaderList  = [[[FBDMManager alloc] init] query:@"select distinct * from ReportHeadList  where TYPECODE = ? and (ISLEAFHEAD = ?  or LINENO = ?) order by CAST(NUMORDER AS int)" withArgumentsInArray:@[self.predicate[@"CODE"],@"Y",@"1"]];
        NSMutableArray *responseOfHeaderList = [[NSMutableArray alloc] init];
        NSMutableArray *responseOfDataList = [[NSMutableArray alloc] init];
        for (int i = 0 ;i<[resultOfHeaderList count];i++) {
            NSDictionary *dict   =  resultOfHeaderList[i];
            [responseOfHeaderList addObject:
             @{
               @"NAME": dict[
                             @"TITLE"
                             ],
               @"CODE": dict[
                             @"HEADNAME"
                             ],
               @"CANORDER": dict[
                             @"CANORDER"
                             ],
               @"WIDTH":dict[
                             @"WIDTH"
                             ]
               }
             ];
            if (i==0) {
                continue;
            }
            [responseOfDataList addObject:dict[
                                                 @"HEADNAME"
                                                 ]];
        }
        returnResult = @{@"responseOfHeaderList":responseOfHeaderList,
                         @"responseOfDataList":responseOfDataList};
    }else if ([@"depositBig" isEqualToString:row[@"DISPLAY"]]){
        NSMutableArray *resultOfHeaderList = [[NSMutableArray alloc]init];
        NSMutableArray *responseOfDataList= [[NSMutableArray alloc]init];
        NSArray *resultOfHeaderList1  = [[[FBDMManager alloc] init] query:@"select distinct * from ReportHeadList  where TYPECODE = ? and LINENO = ? order by CAST(NUMORDER AS int)" withArgumentsInArray:@[self.predicate[@"CODE"],@"1"]];
        for (NSDictionary *dict in resultOfHeaderList1) {
           NSString *name =  dict[@"TITLE"];
            [resultOfHeaderList addObject:name];
        }
        for (int i = 0 ;i<[resultOfHeaderList1 count];i++) {
            NSString *param = resultOfHeaderList1[i][@"ID"];
            NSArray *resultOfHeaderList2  = [[[FBDMManager alloc] init] query:@"select distinct * from ReportHeadList  where TYPECODE = ? and LINENO = ? and PARENTID = ? order by CAST(NUMORDER AS int)" withArgumentsInArray:@[self.predicate[@"CODE"],@"2",param]];
            
            NSMutableArray *arylllllll = [[NSMutableArray alloc]init];
            NSMutableArray *responseOfDataListParam= [[NSMutableArray alloc]init];
            for (NSDictionary *dict in resultOfHeaderList2) {
                [arylllllll addObject:@{
                                        @"NAME": dict[
                                                      @"TITLE"
                                                      ],
                                        @"CODE": dict[
                                                      @"HEADNAME"
                                                      ],
                                        @"CANORDER": dict[
                                                          @"CANORDER"
                                                          ],
                                        @"WIDTH":dict[
                                                      @"WIDTH"
                                                      ]
                                        }];
                   [responseOfDataListParam addObject:dict[@"HEADNAME"]];
            }
            [resultOfHeaderList addObject:arylllllll];
            [responseOfDataList addObject:responseOfDataListParam];
        }
        returnResult = @{@"responseOfHeaderList":resultOfHeaderList,
                         @"responseOfDataList":responseOfDataList};
    }else if (NO){
        //TODO...
    }else if (NO){
        //TODO...
    }else{
        
    }
    return returnResult;
}

NSString* HTMLStringTime (NSString *strTimer){
    return [strTimer stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

id stringNotNull(id mm){
    if (!mm) {
        if ([mm isKindOfClass:[NSString class]]) {
            return @"";
        }
        return @"";
        return  mm = [NSNull null];
    }
    return mm;
}

-(void)didStart{
    self.callbackId = _command.callbackId;
    self.arguments = [_command arguments][0][0][0];
    self.predicate = [_command arguments][0][1];
    [self.predicate setValue:HTMLStringTime(self.predicate[@"CRNDAT"])                     forKey:@"CRNDAT"];
    self.overwrite = [_command arguments][0][2];
    if ([[_command arguments][0] count]>3) {
        _order = [_command arguments][0][3];
    }
    NSString * funName = self.arguments [kfun];
 argumentsRequire(self.arguments[kprarm],stringNotNull(self.predicate[@"CRNDAT"]));
    NSArray * prarmName = _arguments [kprarm];
    NSDictionary * paramters =@{kfun:funName,kprarm: prarmName};
    NSString *jsonOfPrarmters = [[NSString alloc] initWithData:[[CJSONSerializer serializer] serializeDictionary:paramters error:nil] encoding:NSUTF8StringEncoding];
    AresNetOnlyLoadIfNotCachedModel *THEAresNetOnlyLoadIfNotCachedModel = [[AresNetOnlyLoadIfNotCachedModel alloc] initWithForceRefresh:self.predicate[@"REFRESH"]];
    [THEAresNetOnlyLoadIfNotCachedModel docheck:__ServerIP__ aurlParam:jsonOfPrarmters inModel:funName where:nil];//where为空是全查*/
}

static NSArray *interfaceBuild ;
+(void)load{
    interfaceBuild = @[@"bocopReportType"];
}

-(IBAction)aresNetkResultSetSuccess:(NSNotification *)notification{
    id resulstFinal = nil;
    if ([interfaceBuild containsObject:[notification object][@"interface"]]){
        [_ResultSet  addObject:[notification object][@"data"]];
        resulstFinal =  [self overwrite:self.overwrite orderBy:self.order];
    }else if ([[notification object][@"interface"] isEqualToString:@"bocopReportOffice"]){
        [_ResultSet  addObject:[notification object][@"data"]];
        [[AresNetOnlyLoadIfNotCachedModel singleton] docheck:__ServerIP__ aurlParam:__urlParam1__ inModel:@"bocopRetApDay" where:@{@"CRNDAT":_predicate[@"CRNDAT"]}];//where为空是全查
        return;
    }
    [self didEnd:resulstFinal];
}

-(void)didEnd:(id)resulstFinal{
    if (resulstFinal == nil) {
        [self.delegate callBack:CDVPluginResult_Failed() callbackId:_callbackId];
    }else{
    //    showVoice();
        [self.delegate callBack:CDVPluginResult_OK(resulstFinal) callbackId:_callbackId];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AresNetOnlyLoadIfNotCachedModelResultSetSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AresNetOnlyLoadIfNotCachedModelSetFailed object:nil];
}

-(IBAction)aresNetkResultSetFailed:(NSNotification *)notification{
    [_delegate callBack:CDVPluginResult_Failed() callbackId:self.callbackId];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AresNetOnlyLoadIfNotCachedModelResultSetSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AresNetOnlyLoadIfNotCachedModelSetFailed object:nil];
    showShake();
}


//#pragma market -
//#pragma mark ------ 组装报文(存贷款)
-(id)overwrite:(NSString *)type orderBy:(NSArray *)aOrder{
    if (PCDebugFlag) {
        NSLog(@"★★★[时间戳] :组装报文(%@)",type);
    }
    if ([type  isEqualToString:_table_]) {
        return [self ping_table:aOrder];
    }else if ([type  isEqualToString:_home_]) {
        return [self ping_home:aOrder];
    }else if ([type  isEqualToString:_bocopRetLagbalChg_]) {
        return [self ping_bocopRetLagbalChg:aOrder];
    }else if ([type  isEqualToString:_bocopRetLagbalChgPub_]) {
        return [self ping_bocopRetLagbalChgPub:aOrder];
    }else if ([type  isEqualToString:_bocopReportType_]) {
        return [self ping_bocopReportType:aOrder];
    }else{
        return [self ping_table:self.order];
    }
}

// 菜单
-(NSArray *)ping_bocopReportType:(NSArray *)aOrder{
    // 组装
    if (PCLogFlag) {
        NSLog(@"★★★[时间戳] :组装菜单(%@)",@"bocopReportType");
//        NSLog(@"%@",deserializeAsArray(_ResultSet[0]));
    }
    return  deserializeAsArray(_ResultSet[0]);
}

//大额变动
-(NSDictionary *)ping_bocopRetLagbalChg:(NSArray *)aOrder{
    // 组装
    NSMutableArray *aryOfResSet1 = [[NSMutableArray alloc]init];
    NSMutableArray *aryOfResSet2 = [[NSMutableArray alloc]init];
    NSString *aString = _ResultSet[0];
    NSArray *aaryOfString = deserializeAsArray(aString);
    for (NSDictionary *dict  in aaryOfString) {
        NSArray *dictOfString =   @[dict[@"CUSNAM"],dict[@"CUSTNO"],dict[@"TRNAMT"], dict[@"RANKID"]];
        NSString *trn  = dict[@"TRNCDT"];
        if ([trn isEqualToString:@"D"])  {
            [aryOfResSet1 addObject:dictOfString];
        }else{
            [aryOfResSet2 addObject:dictOfString];
        }
    }
    NSArray * aryOfheader = [[CJSONDeserializer deserializer] deserializeAsArray:[chg_head dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    NSDictionary *resulstFinal = @{@"title1":@"大额变动入帐",@"title2":@"大额变动出帐",@"series1": aryOfResSet1,@"series2": aryOfResSet2,@"headers1":aryOfheader,@"headers2":aryOfheader,@"headers":aryOfheader};
    if (PCDebugFlag) {
        NSLog(@"%@",resulstFinal);
    }

    return resulstFinal;
}

//对公大额变动
-(NSDictionary *)ping_bocopRetLagbalChgPub:(NSArray *)aOrder{
    // 组装
    NSMutableArray *aryOfResSet1 = [[NSMutableArray alloc]init];
    NSMutableArray *aryOfResSet2 = [[NSMutableArray alloc]init];
    NSString *aString = _ResultSet[0];
    NSArray *aaryOfString = deserializeAsArray(aString);
    
    //分组
    for (NSDictionary *dict  in aaryOfString) {
        NSArray *dictOfString =   @[dict[@"CUSNAM"],dict[@"CUSTNO"],dict[@"TRNAMT"], dict[@"RANKID"]];
        NSString *trn  = dict[@"TRNCDT"];
        if ([trn isEqualToString:@"D"])  {
            [aryOfResSet1 addObject:dictOfString];
        }else{
            [aryOfResSet2 addObject:dictOfString];
        }
    }
    
    //actionsheet
    NSMutableArray *actionsheetOfString = [[NSMutableArray alloc]init];
    NSDictionary *stander = nil;
    for (NSDictionary * aDict in aaryOfString) {
        if ([aDict[@"ID"] isEqualToString:[NSString stringWithFormat:@"%@",self.predicate[@"ID"]]]) {
            stander = aDict;
            break;
        }
    }
    if (stander) {
        for (NSDictionary * aDict in aaryOfString) {
            if ([aDict[@"PARENT_ID"] isEqualToString:[NSString stringWithFormat:@"%@",stander[@"PARENT_ID"]]]) {
                [actionsheetOfString addObject:aDict];
            }
        }
    }
    NSArray * aryOfheader = [[CJSONDeserializer deserializer] deserializeAsArray:[chgPub_head dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    
    NSDictionary *resulstFinal = @{@"title1":@"大额变动入帐",@"title2":@"大额变动出帐",@"series1": aryOfResSet1,@"series2": aryOfResSet2,@"headers1":aryOfheader,@"headers2":aryOfheader};
    return resulstFinal;
}

-(NSDictionary *)ping_home:(NSArray *)aOrder{
    // 组装
    NSMutableArray *aryOfResSet = [[NSMutableArray alloc]init];
    NSString *aString = _ResultSet[0];
    NSString *bString = _ResultSet[1];
    NSArray *aaryOfString = deserializeAsArray(aString);
    NSArray *copyOfaaryOfString = deserializeAsArray(aString);
    NSArray *baryOfString = deserializeAsArray(bString);
    NSMutableArray *resOfaaryOfString = [[NSMutableArray alloc]init];
    for (NSDictionary * aDict in aaryOfString) {
        if ([aDict[@"ID"] isEqualToString:[NSString stringWithFormat:@"%@",self.predicate[@"ID"]]]) {
            [resOfaaryOfString addObject:aDict];
            for (NSDictionary * copyOfDict in copyOfaaryOfString) {
                if ([aDict[@"ID"] isEqualToString:copyOfDict[@"PARENT_ID"]]) {
                    [resOfaaryOfString addObject:copyOfDict];
                }
            }
        }
    }
    //排序
    aaryOfString  = [[NSArray alloc]initWithArray:resOfaaryOfString];
    for (NSDictionary * aDict in aaryOfString) {
        for (NSDictionary * bDict in baryOfString) {
            if ([aDict[@"ID"] isEqualToString:bDict[@"ORGIDT"]]) {
                NSDictionary *head = @{@"name":aDict[@"NAME"],@"id":aDict[@"ID"]};
                NSArray *data = nil;
                if (bDict) {
                    //数据重新筛选
                    data = @[bDict[@"ORGIDT"],bDict[@"CURRAT"],bDict[@"YTDBAL"]];
                }
                NSMutableArray *aryOfResSetParam = [[NSMutableArray alloc]init];
                [aryOfResSetParam addObject:head];
                [aryOfResSetParam addObjectsFromArray:data];
                [aryOfResSet addObject:aryOfResSetParam];
            }
        }
    }
    NSArray * aryOfheader = [[CJSONDeserializer deserializer] deserializeAsArray:[home_head dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    
    NSDictionary *resulstFinal = @{@"series": aryOfResSet,@"headers":aryOfheader,@"percent":@[@"1",@"2"]};
    return resulstFinal;
}

-(NSDictionary *)ping_table:(NSArray *)aOrder{
    // 组装
    NSMutableArray *aryOfResSet = [[NSMutableArray alloc]init];
    NSString *aString = _ResultSet[0];
    NSString *bString = _ResultSet[1];
    NSArray *aaryOfString = deserializeAsArray(aString);
    NSArray *copyOfaaryOfString = deserializeAsArray(aString);
    NSArray *baryOfString = deserializeAsArray(bString);
    NSMutableArray *resOfaaryOfString = [[NSMutableArray alloc]init];
    NSMutableArray *actionsheetOfString = [[NSMutableArray alloc]init];
    
    //求兄弟节点
    NSDictionary *stander = nil;
    for (NSDictionary * aDict in aaryOfString) {
        if ([aDict[@"ID"] isEqualToString:[NSString stringWithFormat:@"%@",_predicate[@"ID"]]]) {
            stander = aDict;
            break;
        }
    }
    if (stander) {
        for (NSDictionary * aDict in aaryOfString) {
            if ([aDict[@"PARENT_ID"] isEqualToString:[NSString stringWithFormat:@"%@",stander[@"PARENT_ID"]]]) {
                [actionsheetOfString addObject:aDict];
            }
        }
    }
    BOOL isRoot = NO;
       /*特殊处理，根节点求起子节点，根节点唯一*/
    if (actionsheetOfString&&[actionsheetOfString count]==1) {
        isRoot = YES;
    }
    
    //求叶子节点
    for (NSDictionary * aDict in aaryOfString) {
        if ([aDict[@"ID"] isEqualToString:[NSString stringWithFormat:@"%@",self.predicate[@"ID"]]]) {
            [resOfaaryOfString addObject:aDict];
            for (NSDictionary * copyOfDict in copyOfaaryOfString) {
                if ([aDict[@"ID"] isEqualToString:copyOfDict[@"PARENT_ID"]]) {
                    [resOfaaryOfString addObject:copyOfDict];
                    if (isRoot) {
                        [actionsheetOfString addObject:copyOfDict];
                    }
                }
            }
        }
    }
    
    
    //排序
    aaryOfString  = [[NSArray alloc]initWithArray:resOfaaryOfString];
    for (NSDictionary * aDict in aaryOfString) {
        for (NSDictionary * bDict in baryOfString) {
            if ([aDict[@"ID"] isEqualToString:bDict[@"ORGIDT"]]) {
                NSDictionary *head = @{@"name":aDict[@"NAME"],@"id":aDict[@"ID"],@"IS_LEAVE":aDict[@"IS_LEAVE"]};
                NSArray *data = nil;
                if (bDict) {
                    //数据重新筛选
                    data = @[bDict[@"CURBAL"],bDict[@"LSTDAYBAL"],bDict[@"LSTMTHBAL"],bDict[@"LSTYEARBAL"],bDict[@"YTDBAL"],bDict[@"LSTDAYYTD"],bDict[@"LSTMTHYTD"],bDict[@"LSTYEARYTD"],bDict[@"YTDRAT"]];
                }
                
                NSMutableArray *aryOfResSetParam = [[NSMutableArray alloc]init];
                [aryOfResSetParam addObject:head];
                [aryOfResSetParam addObjectsFromArray:data];
                [aryOfResSet addObject:aryOfResSetParam];
            }
        }
    }
    
    //字段排序
    if (aOrder&&[aOrder count]!=0) {
         NSArray *keys  = @[@"CURBAL",@"LSTDAYBAL",@"LSTMTHBAL",@"LSTYEARBAL",@"YTDBAL",@"LSTDAYYTD",@"LSTMTHYTD",@"YTDBAL",@"ORGIDT"];
        NSString *col =  aOrder[0];
        BOOL isMilliOn = NO;
        if ([col isEqualToString:@"CURBAL"]) {
             isMilliOn = YES;
        }
        NSString *des = aOrder[1];
        NSInteger index = [keys indexOfObject:col];
        aryOfResSet =  [self sort:aryOfResSet atIndex:index isDes:(NSString *)des];
    }

    //过滤
    NSMutableArray *cleaner = [[NSMutableArray alloc]init];
    for (NSDictionary * aDict  in actionsheetOfString) {
        NSArray *cleanerParam =  [JSONModel arrayOfDictionariesFromModels: [[[ZIMORMManagerImp alloc] init ] query:@{@"ORGIDT": aDict[@"ID"]} inModel:@"bocopRetApDay"]];
        if (cleanerParam&&[cleanerParam count]!=0) {
            [cleaner addObject:aDict];
        }
    }
    actionsheetOfString = nil;
    actionsheetOfString = cleaner;

    //汇总
    NSArray * aryOfheader = [[CJSONDeserializer deserializer] deserializeAsArray:[report_head dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    NSDictionary *resulstFinal = @{@"series": aryOfResSet,@"headers":aryOfheader,@"actionsheet":actionsheetOfString};   
    return resulstFinal;
}

-(NSMutableArray *)sort:(NSMutableArray *)arr atIndex:(NSInteger)index isDes:(NSString *)des
{
    BOOL isDesc = NO;
    if ([des isEqualToString:@"desc"]) {
        isDesc = YES;
    }
    for (int i=0; i<[arr count]; i++)
    {
        for(int j=i+1;j<[arr count] ;j++)
        {
            NSArray *arr1=[arr objectAtIndex:i];
            NSArray *arr2=[arr objectAtIndex:j];
            NSString *str1 = [arr1 objectAtIndex:index];
            NSString *str2 = [arr2 objectAtIndex:index];
            if (isDesc) {
                if ([str1 doubleValue]>[str2 doubleValue]||[str1 doubleValue]==[str2 doubleValue]) //NSOrderedAscending 为降序    NSOrderedDescending为升序
                {
                    [arr replaceObjectAtIndex:i withObject:arr2];
                    [arr replaceObjectAtIndex:j withObject:arr1];
                }
            }else{
                if ([str1 doubleValue]<[str2 doubleValue]||[str1 doubleValue]==[str2 doubleValue]) //NSOrderedAscending 为降序    NSOrderedDescending为升序
                {
                    [arr replaceObjectAtIndex:i withObject:arr2];
                    [arr replaceObjectAtIndex:j withObject:arr1];
                }
            }
        }
    }
    return arr;
}

@end

@interface BaseFactory : NSObject
@end
@implementation BaseFactory
@end
@protocol NativeNetDOFactory <NSObject>
@required
-(void)nativeNetDOClass:(id)protocol;
@optional
-(NSString *)overwriteTurn:(CDVInvokedUrlCommand *)commend;
@end

@interface NativeNetDOFactory : BaseFactory
@property (strong , nonatomic) id<NativeNetDOFactory> delegate;
-(NativeNetDO *)createNativeNetDO:(CDVInvokedUrlCommand*)commend aNativeNet:(NativeNet *)aNativeNet;
@end

#define Exception_Format [NSString stringWithFormat:@"js调用接口不能为空,请检查js第一个字段"]
@implementation NativeNetDOFactory

-(NSString *)primaryKey:(CDVInvokedUrlCommand *)commend{
    return [commend arguments][0][0][0][kfun];
}

static NSDictionary *NativeNetDOMap;
+(void)load{
    NSData *data=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"InterfaceOfHTML" ofType:@"json"]];
    NSError *error = nil;
    NativeNetDOMap=
    [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments
                                                    error:&error];
}

-(NativeNetDO *)createNativeNetDO:(CDVInvokedUrlCommand*)commend aNativeNet:(NativeNet *)
aNativeNet{
    if (commend&&aNativeNet) {
        NSString *primaryKey =  [self primaryKey:commend];
        if (primaryKey) {
            if (NativeNetDOMap[primaryKey]) {
                NSString *stringOfClassName = NativeNetDOMap[primaryKey];
                return [(NativeNetDO *)[NSClassFromString(stringOfClassName) alloc]initWithCommend:commend delegate:aNativeNet withHtmlInterface:primaryKey];
            }
        }
    }else{
        [NSException raise:NSInternalInconsistencyException
                    format:Exception_Format, [NSString stringWithUTF8String:object_getClassName(self)], NSStringFromSelector(_cmd)];
    }
    return [[NativeNetDO alloc]initWithCommend:commend delegate:aNativeNet];
}
@end



static BOOL isLock = NO;
static NSMutableDictionary *_scheme;
@interface NativeNet()<Depacketize>
@end
@implementation NativeNet

+(void)load{
    if (!_scheme) {
        _scheme = [[NSMutableDictionary alloc] init];
    }
}
/*!
 @method				cancelLastSamecommend:
 @discussion			这个方法是用来判别上去请求是否和新的请求一样，如果一样就      
                            取消
 @param theNativeNetDO 新的请求
 @return                YES: 取消  NO: 不取消
 @updated			2014-07-31
 */
-(BOOL)cancelLastSamecommend:(NativeNetDO *)theNativeNetDO{
    NativeNetDO *last = (NativeNetDO *)[[_scheme allValues] lastObject];
    if ([last campare:theNativeNetDO]) {
        return YES;
    }else{
        return NO;
    }
}

-(void)getData:(CDVInvokedUrlCommand*)commend{
    if (PCTestFlag) {
        NSString * funName =[commend arguments][0][0][0] [kfun];
        if ([funName isEqualToString:@"XXXXXXX"]) {
            return;
        }
    }
    if (PCLogFlag) {
        NSLog(@"[时间戳 :] ★★★进入原生程序");
    }
    NativeNetDO *theNativeNetDO = [[NativeNetDOFactory singleton] createNativeNetDO:commend aNativeNet:self];
    if ([self cancelLastSamecommend:theNativeNetDO]) {
         if (PCLogFlag) {
              NSLog(@"[警告 :] ★★★请勿重复请求");
         }
        if (PCCatchWarningFlag) {
              return;
        }
    }
    [_scheme setObject:theNativeNetDO forKey:commend.callbackId];
    NSLog(@"commend.callbackId%@",commend.callbackId);
    if (!isLock&&[_scheme count]!=0&&[_scheme count]==1) {
        if (PCDebugFlag) {
            NSLog(@"[IOS :] ★★★START 队列数字%d",[_scheme count]);
            NSLog(@"[IOS :] ★★★启动队列%d",[_scheme count]);
        }
        isLock = YES;
        [(NativeNetDO *)[[_scheme allValues] lastObject] start];
    }
}

-(void)callBack:(CDVPluginResult *)result callbackId:(NSString *)callbackId{
    NativeNetDO *removedDO = _scheme[callbackId];
    [_scheme removeObjectForKey:callbackId];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    if(PCDebugFlag){
        NSLog(@"★★★[IOS:] 回调html成功(%@)-----||||||",[removedDO.command arguments][0][0][0][kfun]);
    }
    [AppDelegate  hideAppWaitView];
    isLock = NO;
    if (!isLock) {
        if ([_scheme count]!=0) {
            [(NativeNetDO *)[[_scheme allValues] lastObject] start];
            isLock = YES;
        }else{
            if(PCDebugFlag){
                NSLog(@"★★★[IOS:]  队列任务全部完成-----------------||||||");
            }
            isLock = NO;
        }
    }
}
@end

