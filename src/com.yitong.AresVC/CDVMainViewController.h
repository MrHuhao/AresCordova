/*
 * Licensed Materials - Property of IBM
 * 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */


//
//  CDVMainViewController.h
//  cccTestCordovaIphone
//

enum CDVDestinationType {
    CDVContextStatusWillStartLoad = 0,
    CDVContextStatusDidStartLoad ,
    CDVContextStatusDidFinishLoad,
    CDVContextStatusdidFailLoadWithError
};
typedef NSUInteger CDVContextStatus;

#import "MainViewController.h"

@protocol CDVMainViewControllerDelegate <NSObject>

- (void)CDVDidFinishLoad:(MainViewController *)CDV;
- (void)CDVDidDidStartLoad:(MainViewController *)CDV;
- (void)CDVDidFailLoadWithError:(MainViewController *)CDV;
- (UIWebView *)webView;
@end

@interface CDVMainViewController : MainViewController <UIWebViewDelegate,CDVMainViewControllerDelegate>

@property (strong , nonatomic ) id<CDVMainViewControllerDelegate> delegate;

@property CDVContextStatus cCDVContextStatus;

- (void)jumpToPage:(NSString*)pageName;

@end
