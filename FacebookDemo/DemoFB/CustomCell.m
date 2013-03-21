//
//  CustomCell.m
//  DemoFB
//
//  Created by Innoppl technologies on 20/03/13.
//
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize namelbl,profileImage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        namelbl=[[UILabel alloc] initWithFrame:CGRectMake(62, 0, 200, 35)];
		namelbl.font = [UIFont systemFontOfSize:14.0];
        [namelbl setBackgroundColor:[UIColor clearColor]];
        namelbl.textColor=[UIColor blackColor];
        [self.contentView addSubview:namelbl];
        
    
        
        profileImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 45, 39)];
        [self.contentView addSubview:profileImage];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
