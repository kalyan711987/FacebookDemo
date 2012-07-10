//
//  FriendsView.h
//  DemoApp
//
//  Created by Innoppl tech on 7/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "AsyncImageView.h"
@interface FriendsView : UIViewController {
    NSMutableArray *friendsArray;
    int  indexValue;
    NSMutableData *responceData;
}
@property(nonatomic,assign)    int  indexValue;

@end
