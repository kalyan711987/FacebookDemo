//
//  EducationView.h
//  DemoApp
//
//  Created by Innoppl tech on 7/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "AppDelegate.h"
@interface EducationView : UIViewController {
    int z;
    NSString *responsestring;

}
@property(nonatomic,assign)    int z;
@property(nonatomic,copy)    NSString *responsestring;

-(UILabel*)lblframe:(CGRect)rect text:(NSString*)text;
@end
