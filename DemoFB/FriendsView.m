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

    
     alert= [[UIAlertView alloc] initWithTitle:@"Loading....." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] ;
    [alert show];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    activityIndicator.center = CGPointMake( 140,  65);
    [activityIndicator startAnimating];
    [alert addSubview:activityIndicator]; 
    
// Requesting For the friends list by the access token stored in NSUser defaults    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *_accessToken=[defaults objectForKey:@"Token"];
    NSString *urlString;
    if (indexValue==3) {
        self.navigationItem.title=@"Friends List";

     urlString = [NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@", [_accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }else {
        
        self.navigationItem.title=@"User Likes";

        urlString = [NSString stringWithFormat:@"https://graph.facebook.com/me/likes?access_token=%@", [_accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    }
    
  //  NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString: urlString]];
    [request setHTTPMethod:@"GET"];
    //[request setHTTPBody:postDatastr];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // Create Connection.
    NSURLConnection  *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (conn) {
        // The connection was established.
        responceData = [[NSMutableData alloc] init];
        NSLog( @"Data will be received from URL: %@", request.URL );
    }

   
    [super viewDidLoad];
    
    [self performSelector:@selector(CallTable) withObject:nil afterDelay:4];
   
    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(Closealert) userInfo:nil repeats:NO];
}
-(void)Closealert{
    // Dissmissing the alert view
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)CallTable{
// Creating a table view    
    UITableView *friendsTB=[[UITableView alloc]initWithFrame:CGRectMake(0,0, 320,410) style:UITableViewStylePlain];
    friendsTB.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    friendsTB.dataSource = self;
    friendsTB.delegate = self;
    [self.view addSubview:friendsTB];
   // [friendsTB release];

}
//*** Getting Response for the request
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
   // NSLog(@"count%i",[friendsArray count]);
    return [friendsArray count];
}
#define ASYNC_IMAGE_TAG 9999
#define LABEL_TAG 8888
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AsyncImageView *asyncImageView = nil;
    UILabel *label = nil;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }
    if (cell == nil) {
       // NSLog(@"cell nil");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        CGRect frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size.width = 52;
        frame.size.height = 39;
        asyncImageView = [[AsyncImageView alloc] initWithFrame:frame];
        asyncImageView.tag = ASYNC_IMAGE_TAG;
        [cell.contentView addSubview:asyncImageView];
        frame.origin.x = 52 + 10;
        frame.size.width = 200;
        label = [[UILabel alloc] initWithFrame:frame];
        label.tag = LABEL_TAG;
        [cell.contentView addSubview:label];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        //NSLog(@"cell not nil");
        
        asyncImageView = (AsyncImageView *) [cell.contentView viewWithTag:ASYNC_IMAGE_TAG];
        label = (UILabel *) [cell.contentView viewWithTag:LABEL_TAG];
    }
    // Loading images asynchrounously.......

    NSString *urlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",
                           [[friendsArray objectAtIndex:indexPath.row] objectForKey:@"id" ]];
    NSURL *url = [NSURL URLWithString:urlString];
    [asyncImageView loadImageFromURL:url];
    
    label.text = [[friendsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
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
