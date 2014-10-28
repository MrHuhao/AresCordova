/**
 *  
    胡皓
 -------------------------------------------------------
 上海屹通信息科技股份有限公司
 地址：海宁路269号森林湾大厦B栋 6楼 200080
 电话：021-63093688，63093686
 传真：021-63093687
 手机：1865558712
 邮箱：hh@yitong.com.cn
 QQ：  334177726
  -------------------------------------------------------pod
 *  Pod::Spec.new do |s|
 s.name             = "WZMarqueeView"
 s.version          = "1.0.0"
 s.summary          = "A marquee view used on iOS."
 s.description      = <<-DESC
 It is a marquee view used on iOS, which implement by Objective-C.
 DESC
 s.homepage          = "334177726@qq.com"
 # s.screenshots      = "334177726@qq.com", "334177726@qq.com"
 s.license          = 'MIT'
 s.author           = { "胡皓" => "334177726@qq.com" }
 s.source           = { :git => "", :tag => s.version.to_s }
 # s.social_media_url = ''
 
 s.platform     = :ios, '4.3'
 # s.ios.deployment_target = '5.0'
 # s.osx.deployment_target = '10.7'
 s.requires_arc = true
 
 s.source_files = 'src/*'
 # s.resources = 'Assets'
 
 # s.ios.exclude_files = 'Classes/osx'
 # s.osx.exclude_files = 'Classes/ios'
 # s.public_header_files = 'Classes/*.h'
 # s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'

end
*/


/**
 *  Ares协议通知
 */
#define kAresLoginSuccess @"kAresLoginSuccess"
@protocol AppDelegateProtocol

-(BOOL)application:(NSNotification *)notification;

- (void)application:(UIApplication *)application didFinishContextWithOptions:(NSDictionary *)launchOptions;

+(void)showAppWaitView;

+(void)hideAppWaitView;

@end

#import <UIKit/UIKit.h>

@class BOCOPPay;
@class AresFstLogSession;

#import "NSObject+Singleton.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,AppDelegateProtocol>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITableView *viewController;

@property (nonatomic, strong) UIViewController *splashScreen;

@property (nonatomic, strong) UINavigationController *rootViewController;

/**BOCOPPaySDK 的bocPay 其中包含了登录控件*/
@property (strong, nonatomic) BOCOPPay *bocPay;

-(BOOL)appUpdate;

//清空所有缓存(doc目录下的数据库文件)
+(void)appCleaner;

//退出应用
-(void)doExit;

//网络未知提示
-(void)showNotifitionView;

@end
