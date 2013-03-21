//
//  AppDelegate.h
//  DemoFB
//
//  Created by sathish kumar on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccount *facebookAccount;
@end
