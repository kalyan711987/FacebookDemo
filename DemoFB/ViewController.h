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
#import <Accounts/Accounts.h>
#import <Social/Social.h>
@interface ViewController : UIViewController<UIWebViewDelegate>{
   
    UIActivityIndicatorView *_spinner;
    NSMutableData *responceData;
    BOOL Redirect;
    AppDelegate *appdell;
    UIAlertView *alert;

}
@property(nonatomic,retain)    UIWebView *webview;
//test
@end
