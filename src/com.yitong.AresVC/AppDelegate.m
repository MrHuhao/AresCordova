//  YTDownLoaderAppDelegate.m
//  YTDownLoader
//
//  Created by 胡皓 on 14-7-21.
//  Copyright (c) 2014年 胡皓. All rights reserved.
//
#define webkitUserSelect @"document.documentElement.style.webkitUserSelect='none';"
#define webkitTouchCallout @"document.documentElement.style.webkitTouchCallout='none';"
#import "GestureLockViewController.h"
#import <dispatch/queue.h>
#import "AppDelegate.h"
#import "AppRegister.h"
#import "AresFstLogSession.h"
#import "AresSession.h"
#import "CDVMainViewController.h"


#import "AresAppFilterDB.h"
#import "AFNetworkReachabilityManager.h"
#import "CSNotificationView.h"
#import "ZIMORMManagerImp.h"
#import "MBProgressHUD.h"
#import "UIAlertView+Blocks.h"
#import "YKFile+NSDirectories.h"
#import "NSDateFormatter+NTDDateFormatter.h"
#import "UIImage+ImageEffects.h"
#import "UIView+ScreenShot.h"
@interface AppDelegate()
{
    GestureLockViewController *gestureLockVC;
}
@property (strong, nonatomic)  NSTimer *timer;
@property (strong, nonatomic) MBProgressHUD *HUD;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [AppRegister addAppRegister:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationLoginSuccess:) name:kAresLoginSuccess object:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if  (![self applicationCDV:application didFinishLaunchingWithOptions:nil]){
        exit(0);
    }
    if (!_splashScreen) {
        _splashScreen = [[NSClassFromString(@"PNCLoadingViewController") alloc]initWithNibName:@"PNCLoadingViewController" bundle:nil];
    }
    [self beginSplashScreen];
    return YES;
}

-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if  (![self applicationCDV:application didFinishLaunchingWithOptions:nil]){
        exit(0);
    }
    /**
     *  SplashScreen
     */
    [self beginSplashScreen];
    return YES;
}

-(void)beginSplashScreen{
    [[(UIViewController *)self.viewController view] addSubview:_splashScreen.view];
}

-(void)endSplashScreen{
    [self performSelector:@selector(xx) withObject:nil afterDelay:0.15];
    [UIView animateWithDuration:1.0f animations:^{
        [_splashScreen.view setAlpha:0.0];
    } completion:^(BOOL finished) {
         [_splashScreen.view removeFromSuperview];
    }];
}

-(void)xx{
    [self showGestureLockViewController:YES];
}
/**
 *  初始化CDV
 *
 *  @param applicationCDV applicationCDV description
 *  @param launchOptions  launchOptions description
 *
 *  @return return value description
 */

- (BOOL)applicationCDV:(UIApplication *)applicationCDV didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    Class someClass = NSClassFromString(@"CDVMainViewController");
    self.viewController = [[someClass alloc] initWithNibName:@"CDVMainViewController" bundle:nil];
    self.viewController.delegate = (id<UITableViewDelegate>)self;
    [[[(CDVMainViewController *)self.viewController webView] scrollView] setShowsHorizontalScrollIndicator:YES];
    [[[(CDVMainViewController *)self.viewController webView] scrollView] setShowsVerticalScrollIndicator:YES];
    _rootViewController = [[UINavigationController alloc]initWithRootViewController: (UIViewController *)self.viewController];
    [_rootViewController.navigationBar setHidden:YES];
    [self.window setRootViewController:_rootViewController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

/**
 *  native 入口
 *
 *  @param application   app
 *  @param launchOptions launchOptions
 */
- (void)application:(UIApplication *)application didFinishContextWithOptions:(NSDictionary *)launchOptions{
        if ([self respondsToSelector:@selector(CDVApplication:didFinishLaunchingWithOptions:)]) {
            [self application:application willFinishContextWithOptions:launchOptions];
            //before you can do somthing
            [self CDVApplication:application didFinishLaunchingWithOptions:launchOptions];
            //after you can do somthing
        }
    [self performSelector:@selector(endSplashScreen) withObject:nil afterDelay:1.0];
}


- (void)application:(UIApplication *)application willFinishContextWithOptions:(NSDictionary *)launchOptions{
    UIWebView *webView = [(CDVMainViewController *)self.viewController webView];
    webView.scrollView.scrollEnabled = NO;
    [webView stringByEvaluatingJavaScriptFromString:webkitUserSelect];
    [webView stringByEvaluatingJavaScriptFromString:webkitTouchCallout];
    [self initAppWaitView];
}

- (BOOL)CDVApplication:(UIApplication *)CDVApplication didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    NSLog(@"didFinishLaunchingWithOptions");
    return YES;
}

-(void)CDVDidFailLoadWithError:(UIViewController *)CDV{
     NSLog(@"CDVDidFailLoadWithError");
     exit(0);
}

-(void)CDVDidDidStartLoad:(UIViewController *)CDV{
    NSLog(@"CDVDidDidStartLoad");
}

-(void)CDVDidFinishLoad:(UIViewController *)CDV{
    static dispatch_once_t onceToken;
    if (PCDebugFlag) {
        if (onceToken) {
           @try {
            }
            @catch (NSException *exception) {
            }
            @finally {
                @throw [NSException exceptionWithName:@"CDVException" reason:@"重复刷新页面" userInfo:nil];
            }
        }
    }
    dispatch_once(&onceToken, ^{
        [self application:nil didFinishContextWithOptions:nil];
    });
}

/**
 *  0：未登陆 1:登陆
 */
static int isloginSuccess = 0;
-(BOOL) applicationLoginSuccess:(NSNotification *)notification
{
    isloginSuccess = 1;
    if (isloginSuccess) {
//         [AresSession singleton].theAresFstLogSession = [[AresFstLogSession alloc]initWithDictionary:[notification object] error:nil];
        [AresSession singleton].theAresFstLogSession = [[AresFstLogSession alloc] initWithDictionary:@{@"userId":@"123",@"orgId":@"A0013",@"orgName":@"全辖"} error:nil];
        NSLog(@"建立session完成!!");
        //建表
        [[ZIMORMManagerImp singleton] loadOrm];
        //拦截器（刷新 机构表，菜单表，主页表 等类版本数据）
        //刷新规则： 每天刷新一次
        AresAppFilterBase *theAresAppFilterDB = [[AresAppFilterDB alloc]init];
        if ([self appUpdate]) {
            [theAresAppFilterDB filter];
        }
        //远程擦除
        //        [(AppDelegate *)[UIApplication sharedApplication].delegate appDBCleaner:^(NSInteger buttonIndex) {
        //
        //        } cc:^(NSInteger buttonIndex) {
        //
        //        } dd:^(NSInteger buttonIndex) {
        //            
        //        }];

    }
    return YES;
}

#pragma market - 
#pragma mark 应用级等待层
-(void)initAppWaitView{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkWaitView) userInfo:nil repeats:YES];
    self.HUD = [[MBProgressHUD alloc] initWithWindow:self.window];
    [self.rootViewController.view addSubview:self.HUD];
    self.HUD.labelText = @"请等待 ...";
}

+(void)showAppWaitView:(BOOL)abool whileExecutingBlock:(dispatch_block_t)block {
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [[app HUD]show:YES];
}

+(void)hideWaitView:(BOOL)abool whileExecutingBlock:(dispatch_block_t)block {
    
}

static int releaseOne = 0;
+(void)showAppWaitView{
         releaseOne  = releaseOne + 1;
        if (PCDebugFlag) {
            NSLog(@"显示等待层%d",releaseOne);
        }
     if (releaseOne>0) {
        AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
        [[app HUD] show:YES];
     }
}

-(void)checkWaitView{
    if (releaseOne>0) {
        AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
        [[app HUD] show:YES];
    }
    if (releaseOne==0) {
        AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
        [[app HUD] hide:YES];
    }
}

+(void)hideAppWaitView{
        if (PCDebugFlag) {
            NSLog(@"关闭等待层%d",releaseOne);
        }
        releaseOne = releaseOne - 1;
    if (releaseOne==0) {
        AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
        [[app HUD] hide:YES];
    }
}

-(void)showGestureLockViewController:(BOOL)animated{
    gestureLockVC = [[GestureLockViewController alloc] initWithNibName:@"GestureLockViewController" bundle:nil];
    [gestureLockVC.view setBackgroundColor:[UIColor clearColor]];
    UIImage *imgShot =[self.rootViewController.topViewController.view screenshot];
    imgShot=[imgShot applyExtraLightEffect];
    gestureLockVC.bgImage.image =imgShot;
    gestureLockVC.delegate = self;
    if([gestureLockVC hasGestureLock]) {
        gestureLockVC.mode = GestureLockViewInput;
           [gestureLockVC show:GestureLockViewAddView inParentViewController:self.rootViewController animated:(BOOL)animated];
        return;
    }
    else {
        gestureLockVC = [[GestureLockViewController alloc] initWithNibName:@"GestureLockViewController" bundle:nil];
        gestureLockVC.delegate = self;
        gestureLockVC.mode = GestureLockViewSet;
           [gestureLockVC show:GestureLockViewAddView inParentViewController:self.rootViewController animated:(BOOL)animated];
    }
}

- (void)GestureLockInputOK{
    [gestureLockVC.view removeFromSuperview];
}

//版本更新规则
-(BOOL)appUpdate{
    if (appUpdateRuleFORCE()||(appUpdateRuleA()&&appUpdateRuleB()&&appUpdateRuleC())) {
        return YES;
    }
    return NO;
}

//强力规则规则( 建议写成服务器规则 )
BOOL appUpdateRuleFORCE(){
    return YES;
      //TODO...
    return NO;
}

//规则3
BOOL appUpdateRuleC(){
    return YES;
}

//规则2
BOOL appUpdateRuleB(){
    return YES;
}

//规则1大于一天
BOOL appUpdateRuleA(){
    NSDateFormatter *theNSDateFormatter = [[NSDateFormatter alloc]init];
    [theNSDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateStr = [theNSDateFormatter stringFromDate:currentDate];
    NSDate *strOfCurrentDate =[theNSDateFormatter dateFromString:currentDateStr];
    NSArray *reslut = [[[FBDMManager alloc]init] query:@"select MAX(TIME) from appVersion " withArgumentsInArray:nil];
    if ([reslut count]==1&&reslut[0][@"MAX(TIME)"]&&![reslut[0][@"MAX(TIME)"] isKindOfClass:[NSNull class]]) {
         NSDate *dateOfAppActiveSession = [theNSDateFormatter dateFromString:reslut[0][@"MAX(TIME)"]];
        if (earlyThan(timeInterval(dateOfAppActiveSession),timeInterval(strOfCurrentDate))) {
             [[[ZIMORMManagerImp alloc] init] save:@[@{@"TIME":currentDateStr,@"TURN":@"1"}]inModel:@"appVersion"];
            return YES;
            //需要更新
        }else{
            NSArray *reslutq = [[[FBDMManager alloc] init] query:@"select * from appVersion " withArgumentsInArray:nil];
            if (![reslutq[0][@"TURN"] isEqualToString:@"1"]) {
                [[[ZIMORMManagerImp alloc] init] save:@[@{@"TIME":currentDateStr,@"TURN":@"1"}] inModel:@"appVersion"];
                return YES;
                //需要更新
            }else{
                return NO;
                //不需要更新
            }
        }
    }else{
        //第一次登录,需要更新
        [[[ZIMORMManagerImp alloc] init] save:@[@{@"TIME":currentDateStr,@"TURN":@"1"}] inModel:@"appVersion"];
        return YES;
    }
    return NO;
}

NSTimeInterval timeInterval (NSDate *date){
  return  [date timeIntervalSince1970]*1;
}

bool earlyThan (NSTimeInterval datel,NSTimeInterval dater){
    if (datel-dater>0) {
        return YES;
    }
    return NO;
}

//退出应用
-(void)doExit{
    [UIAlertView showWithTitle:@"中国银行" message:@"确认退出？" cancelButtonTitle:@"是" otherButtonTitles:@[@"否"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if(buttonIndex ==0){
               exit(0);
        }else {
            //do nothing
        }
    }];
}

//清空所有缓存(doc目录下的数据库文件)
+(void)appCleaner{
    [[YKFile documentsDirectory] remove];
}

-(void)checkConnectToHost{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status==AFNetworkReachabilityStatusNotReachable) {
            if ([AFNetworkReachabilityManager sharedManager].isReachable) {
                 NSLog(@"有网络");
                 return ;
            }
            NSLog(@"没有网络");
            return ;
        }
        if (status ==  AFNetworkReachabilityStatusReachableViaWWAN||status == AFNetworkReachabilityStatusReachableViaWiFi) {
            if (![AFNetworkReachabilityManager sharedManager].isReachable) {
                NSLog(@"没有网络");
                return ;
            }
            NSLog(@"有网络");
            return;
        }
    }];
}

-(void)showNotifitionView{
    return;
    [CSNotificationView showInViewController:self.rootViewController
                                       style:CSNotificationViewStyleError
                                     message:@"网络链接异常!!"];
}
@end
