//
//  FriendsView.m
//  DemoApp
//
//  Created by Innoppl tech on 7/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendsView.h"


@implementation FriendsView
@synthesize indexValue;
UIAlertView *alert;
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
//    [super dealloc];
//    [friendsArray release];
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
    friendsArray=[[NSMutableArray alloc]init];
    AppDelegate *appdell=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
     alert= [[UIAlertView alloc] initWithTitle:@"Loading....." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] ;
    [alert show];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    activityIndicator.center = CGPointMake( 140,  65);
    [activityIndicator startAnimating];
    [alert addSubview:activityIndicator]; 
    
    [self CallTable];
// Requesting friends list
    if (indexValue==3) {
        self.navigationItem.title=@"Friends List";

    // urlString = [NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@", [_accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me/friends"];
        
        SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                  requestMethod:SLRequestMethodGET
                                                            URL:meurl
                                                     parameters:nil];
        
        merequest.account = appdell.facebookAccount;
        
        [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];

            NSString *meDataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *responceJson=[meDataString JSONValue];
            NSLog(@"getting friends %@", responceJson);
             friendsArray=[[responceJson objectForKey:@"data"] copy];
            
            [friendsTB reloadData];
        }];

    }else {
        
        self.navigationItem.title=@"User Likes";

      //  urlString = [NSString stringWithFormat:@"https://graph.facebook.com/me/likes?access_token=%@", [_accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me/likes"];
        
        SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                  requestMethod:SLRequestMethodGET
                                                            URL:meurl
                                                     parameters:nil];
        
        merequest.account = appdell.facebookAccount;
        
        [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];

            NSString *meDataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSMutableDictionary *responceJson=[meDataString JSONValue];
            NSLog(@"getting likes  %@", responceJson);
            friendsArray=[[responceJson objectForKey:@"data"] copy];
            
            [friendsTB reloadData];
        }];

    }
    
    
    [super viewDidLoad];
    
   
}

-(void)CallTable{
// Creating a table view    
    friendsTB=[[UITableView alloc]initWithFrame:CGRectMake(0,0, 320,410) style:UITableViewStylePlain];
    friendsTB.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    friendsTB.dataSource = self;
    friendsTB.delegate = self;
    [self.view addSubview:friendsTB];
   // [friendsTB release];

}

#pragma mark-------------Tableview Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
   // NSLog(@"count%i",[friendsArray count]);
    return [friendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
     // Loading images asynchrounously.......

    NSString *urlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",
                           [[friendsArray objectAtIndex:indexPath.row] objectForKey:@"id" ]];
   NSURL *url = [NSURL URLWithString:urlString];
    [cell.profileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"pic.png"]];
    cell.namelbl.text = [[friendsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
   // cell.textLabel.text=[[friendsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}
#pragma mark Webservice methods.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
    [responceData setLength:0];
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [responceData appendData:data];
    
}
- (void)connection:(NSURLConnection *)connectiondidFailWithError:(NSError *)error

{   
    NSLog(@"Connection failed! Error - %@ %@",[error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    UIAlertView *AlertErr=[[UIAlertView alloc]initWithTitle:@"Message" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [AlertErr show];
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    NSString *loginStatus = [[NSString alloc] initWithBytes: [responceData mutableBytes] length:[responceData length] encoding:NSUTF8StringEncoding];
    NSLog(@"finish loading data %@",loginStatus);
    NSMutableDictionary *responseJSON = [loginStatus JSONValue];
    friendsArray=[[responseJSON objectForKey:@"data"] copy];
   
    // [proview release];
    
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
