//
//  NativeSession.m
//  BOC
//
//  Created by 胡皓 on 14-9-10.

/**
 *  [NativeSession ,publicInit ,[]]
 *
 *  @return publicInit
 */

#import "NativeSession.h"
@implementation NativeSession

/**
 *  @update 胡皓 2014-9-1
 *  @when html pluign has been Ready,it need can this method adn ioser also need do somthing about codova ,otherwise u cannot do anthing
     like setsession by webview'js
 */

-(void)publicInit:(CDVInvokedUrlCommand*)commend{
//    [[NSNotificationCenter defaultCenter] postNotificationName:kAresCordovaSuccess object:nil];
    if ([[commend arguments] count]>0) {
        @throw [NSException exceptionWithName:@"#warning!"
                                       reason:[NSString stringWithFormat:@"pluign has been Ready method has no paramter!!"]
                                     userInfo:nil];
    }
    CDVViewController *web = (CDVViewController *)self.viewController;
    NSString *htmlOfSession = [[AresSession singleton].theAresFstLogSession toJSONString];
    [[web webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"Ares.init(%@)",htmlOfSession]];
    NSLog(@"为html初始化session");
}

@end
