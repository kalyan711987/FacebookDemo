//
//  ProfileInfoView.h
//  DemoApp
//
//  Created by Innoppl tech on 7/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "JSON.h"
#import "FriendsView.h"
#import "EducationView.h"
@interface ProfileInfoView : UIViewController {
    UITableView *ProfileTable;
    UIImageView *proImg;
    NSString *str;
    NSMutableArray *ArrayMut;
    NSMutableArray *FriendArray;
    NSString *str2;
    NSMutableDictionary *responseJSON;
    NSMutableDictionary *resJSON;
    NSString *resString;
}
@property(nonatomic,copy)    NSString *str;
-(UILabel*)lbltag:(NSInteger)tag text:(NSString*)text rect:(CGRect)rect;
@end
