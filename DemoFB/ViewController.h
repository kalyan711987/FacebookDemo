//
//  ViewController.h
//  DemoFB
//
//  Created by sathish kumar on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ProfileInfoView.h"
@interface ViewController : UIViewController<UIWebViewDelegate>{
   UIWebView *webview;
   UIActivityIndicatorView *_spinner;
    NSMutableData *responceData;
    BOOL Redirect;
    
}
@property(nonatomic,retain)    UIWebView *webview;
-(void)checkForAccessToken:(NSString *)urlString;
-(void)checkLoginRequired:(NSString *)urlString;
@end
