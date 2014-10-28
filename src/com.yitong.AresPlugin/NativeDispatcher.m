/*
 @dispatherCode
 @postName exitApp
 param{
 
 }
 */
#import "NativeDispatcher.h"
#import "AppRegister.h"
/**
 *  注释：插件异步，回调不能代表插件执行完毕了，同步请自行处理
 */
#define strOfname @"name"
#define strOftarget @"target"
#define strOfaction @"action"
#define strOfparam @"param"
#define callBackParam @{@[@"MSG"]: @[@"AAAAAAA"]}
#define NativeDispatcherMainPath [[NSBundle mainBundle] pathForResource:@"CDVPlugin" ofType:@"json"]
#define NotNull(ary) [ary count]>1&&[ary[1] count]>0?ary[1]:@[]

#define __dictOfNativeDispatcher__ dictOfNativeDispatcher[NSStringFromClass([self class])][NSStringFromSelector(_cmd)]

#define __name__ __dictOfNativeDispatcher__[postName][@"name"]
#define __object__ __dictOfNativeDispatcher__[postName][@"object"]

#import "CJSONDeserializer.h"
static NSDictionary *dictOfNativeDispatcher;
@implementation NativeDispatcher

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dictOfNativeDispatcher = [[CJSONDeserializer deserializer] deserializeAsDictionary:[NSData dataWithContentsOfFile:NativeDispatcherMainPath] error:nil];
        NSLog(@"[CDVPlugin]: |read Plugin path....| \n(%@)",NativeDispatcherMainPath);
        NSLog(@"[CDVPlugin]: |regist Plugin begin....|");
        
        NSArray *methodes = [dictOfNativeDispatcher[NSStringFromClass([self class])] allKeys];
        
        for (NSString *method in methodes) {
            NSDictionary *dictOfPluign =  dictOfNativeDispatcher[NSStringFromClass([self class])][method];
            for (NSString *key in [dictOfPluign allKeys]) {
                 NSString *name =  dictOfPluign[key][strOfname];
            }
        }
        NSLog(@"[CDVPlugin]: |%@|",@"regist Plugin end....");
    });
}

-(void)ddd:(NSDictionary *)actionAndTarget{
    NSLog(@"[CDVPlugin]: |%@|",@"do Plugin task begin....");
    id target = [AppRegister shareRegister][actionAndTarget[strOftarget]];
    NSLog(@"%@",target);
    SEL asel =  NSSelectorFromString(actionAndTarget[strOfaction]);
    id obj = actionAndTarget[strOfparam];
    if (target&&[target respondsToSelector:asel]) {
        [target performSelector:asel withObject:obj];
        NSLog(@"[CDVPlugin]: |%@|",@"do Plugin task finished....");
    }
}

-(void)nativeDispatcher:(CDVInvokedUrlCommand*)commend;{
    NSString *postName = [commend arguments][0];
    NSArray *parameter =  NotNull([commend arguments]);
    NSLog(@"[CDVPlugin]: |get the task  Plugin name :(%@)|",postName);
    NSDictionary *paramOfDict =  [self insteadOfvalue:parameter withKey:strOfparam inDictionary:__object__];
    [self ddd:paramOfDict];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:callBackParam];
    [self.commandDelegate sendPluginResult:result callbackId:commend.callbackId];
}

#pragma market - util
-(NSDictionary *)insteadOfvalue:(id)value withKey:(NSString *)key inDictionary:(NSDictionary *)dictionary{
    NSMutableDictionary *paramOfTable = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    [paramOfTable setObject:value forKey:key];
    NSDictionary *paramOfDict  = [[NSDictionary alloc]initWithObjects:[paramOfTable allValues] forKeys:[paramOfTable allKeys]];
    return paramOfDict;
}
@end
