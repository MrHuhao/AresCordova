//
//  PNCLoadingViewController.h
//  MobileAppProjMobileAppIpad
//
//  Created by 彭小坚 on 14-6-25.
//
//

#import <UIKit/UIKit.h>
//typedef  void (^LoadingBlock)(void);
@interface PNCLoadingViewController : UIViewController<UIGestureRecognizerDelegate>
//@property(nonatomic,copy) LoadingBlock loadingBlock;
@property(nonatomic,strong) IBOutlet UIImageView *imageview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil postData:(NSData*)postData;
@end
