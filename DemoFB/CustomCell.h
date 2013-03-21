//
//  CustomCell.h
//  DemoFB
//
//  Created by Innoppl technologies on 20/03/13.
//
//

#import <UIKit/UIKit.h>
@interface CustomCell : UITableViewCell{
    
    
    UILabel *namelbl;
	UIImageView *profileImage;
}
@property(nonatomic, retain) UILabel *namelbl;

@property(nonatomic, retain) UIImageView *profileImage;
@end
