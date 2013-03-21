//
//  FriendsView.h
//  DemoApp
//
//  Created by Innoppl tech on 7/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "AppDelegate.h"
#import "CustomCell.h"
#import "UIImageView+AFNetworking.h"
@interface FriendsView : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *friendsArray;
    int  indexValue;
    NSMutableData *responceData;
    UITableView *friendsTB;
}
@property(nonatomic,assign)    int  indexValue;

@end
