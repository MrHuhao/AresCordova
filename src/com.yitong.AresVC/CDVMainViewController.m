/*
 * Licensed Materials - Property of IBM
 * 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

//  CDVMainViewController.m
//  cccTestCordovaIphone
//  categary by huhao@yitong.com.cn

#import "CDVMainViewController.h"

@interface CDVMainViewController() {
    NSString * _pageName;
}
@end

@implementation CDVMainViewController

-(void)initStatusBar{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIView *StatusBarbg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [StatusBarbg setBackgroundColor:[UIColor colorWithRed:207.0/255.0 green:0/255.0 blue:28.0/255.0 alpha:1.0f]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, StatusBarbg.frame.size.width, 20)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:13.0f]];
    [StatusBarbg addSubview:label];
    [self.view insertSubview:StatusBarbg atIndex:0];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _cCDVContextStatus = CDVContextStatusWillStartLoad;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self initStatusBar];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

#pragma mark - WebView Delegate

/**
 * Called when the UIWebView finishes loading.  This stops the activity view and closes the imageview.
 */
- (void)webViewDidFinishLoad:(UIWebView *)theWebView 
{
    if (_delegate&&[_delegate respondsToSelector:@selector(CDVDidFinishLoad:)]) {
        [_delegate CDVDidFinishLoad:self];
    }
    _cCDVContextStatus = CDVContextStatusDidFinishLoad;
	return [ super webViewDidFinishLoad:theWebView ];
}

- (void)webViewDidStartLoad:(UIWebView *)theWebView 
{
    if (_delegate&&[_delegate respondsToSelector:@selector(CDVDidDidStartLoad:)]) {
        [_delegate CDVDidDidStartLoad:self];
    }
    _cCDVContextStatus = CDVContextStatusDidStartLoad;
	return [ super webViewDidStartLoad:theWebView ];
}

/**
 * Fail Loading With Error
 * Error - If the web page failed to load display an error with the reason.
 */
- (void)webView:(UIWebView *)theWebView didFailLoadWithError:(NSError *)error 
{
    if (_delegate&&[_delegate respondsToSelector:@selector(CDVDidFailLoadWithError:)]) {
        [_delegate CDVDidFailLoadWithError:self];
    }
    _cCDVContextStatus = CDVContextStatusdidFailLoadWithError;
	return [ super webView:theWebView didFailLoadWithError:error ];
}

/**
 * Start Loading Request
 * This is where most of the magic happens... We take the request(s) and process the response.
 * From here we can redirect links and other protocols to different internal methods.
 */
- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return [ super webView:theWebView shouldStartLoadWithRequest:request navigationType:navigationType ];
}

//跳转页面
- (void)jumpToPage:(NSString*)pageName
{
    _pageName = pageName;
    NSString * funcJump = [NSString stringWithFormat:@"Ares.Page.load('%@');",_pageName];
    [self.webView stringByEvaluatingJavaScriptFromString:funcJump];
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



/* Comment out the block below to over-ride */
/*
 #pragma mark - CDVCommandDelegate implementation
 
 - (id) getCommandInstance:(NSString*)className
 {
 return [super getCommandInstance:className];
 }
 
 - (void) registerPlugin:(CDVPlugin*)plugin withClassName:(NSString*)className
 {
 return [super registerPlugin:plugin withClassName:className];
 }
 */

//- (BOOL)shouldAutorotate
//{
//
//    return NO;
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscape;
//}

@end
