//
//  AppRegister.m
//  MobileAppProjMobileAppIpad
//
//  Created by huhao on 14-8-15.
//
//

#import "AppRegister.h"
static  NSMutableDictionary *controllerMap;
@implementation AppRegister

+(NSDictionary *)shareRegister{
    if (!controllerMap) {
        controllerMap = [[NSMutableDictionary alloc]init];
    }
    return controllerMap;
}


+(void)addAppRegister:(id)menber{
    if (!controllerMap) {
        controllerMap = [[NSMutableDictionary alloc]init];
    }
    if (menber) {
        if ([controllerMap objectForKey:NSStringFromClass([menber class])]) {
            NSLog(@"[#Warning#]:%@ 可能重复注册！！",NSStringFromClass([menber class]));
        }
        [controllerMap setObject:menber forKey:NSStringFromClass([menber class])];
    }
}

@end
