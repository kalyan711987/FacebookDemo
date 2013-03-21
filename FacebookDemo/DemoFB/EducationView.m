//
//  EducationView.m
//  DemoApp
//
//  Created by Innoppl tech on 7/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "EducationView.h"


@implementation EducationView
@synthesize z,responsestring;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
   // [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    NSLog(@"streeeee%@",responsestring);
  NSMutableDictionary  *responseJSON= [responsestring JSONValue];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (z==1) {
// called when user clicks the Works
        self.navigationItem.title=@"Work";

        NSArray *eduArray=[responseJSON objectForKey:@"work"];
        int y=0;
        for (int i=0; i<[eduArray count]; i++) {
            
            [self.view addSubview:[self lblframe:CGRectMake(2, 20+y, 100,40) text:[[[eduArray objectAtIndex:i]objectForKey:@"employer"]objectForKey:@"name"]]];
            [self.view addSubview:[self lblframe:CGRectMake(110,20+y,200,40) text:[[[eduArray objectAtIndex:i] objectForKey:@"position"] objectForKey:@"name"]]];
            y=y+50;
            
        }

        
    }else{
        self.navigationItem.title=@"Education";

        NSArray *eduArray=[responseJSON objectForKey:@"education"];
    int y=0;
    for (int i=0; i<[eduArray count]; i++) {
        
    [self.view addSubview:[self lblframe:CGRectMake(2, 20+y, 100,40) text:[[eduArray objectAtIndex:i]objectForKey:@"type"]]];
    [self.view addSubview:[self lblframe:CGRectMake(110,20+y,200,40) text:[[[eduArray objectAtIndex:i] objectForKey:@"school"] objectForKey:@"name"]]];
        y=y+50;

    }
}
    [super viewDidLoad];
}

//** Coustom method to create labels
-(UILabel*)lblframe:(CGRect)rect text:(NSString*)text{
    
    UILabel *lbl=[[UILabel alloc]initWithFrame:rect];
    [lbl setText:text];
    [lbl setTextColor:[UIColor blackColor]];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setFont:[UIFont boldSystemFontOfSize:14]];
    lbl.lineBreakMode=UILineBreakModeWordWrap;
    lbl.numberOfLines=2;
    return lbl;
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
