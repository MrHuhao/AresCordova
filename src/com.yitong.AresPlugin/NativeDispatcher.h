
#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
//{NativeDispatcher nativeDispatcher [loginOut]}
@interface NativeDispatcher : CDVPlugin
-(void)nativeDispatcher:(CDVInvokedUrlCommand*)commend;
@end