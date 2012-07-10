//
//  ProfileInfoView.m
//  DemoApp
//
//  Created by Innoppl tech on 7/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileInfoView.h"


@implementation ProfileInfoView
@synthesize str;

NSArray *schoolArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Logout" style: UIBarButtonItemStyleBordered target: self action: @selector(Logout:)];       
        self.navigationItem.leftBarButtonItem = newBackButton; 
       // [newBackButton release];
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
//    [super dealloc];
//    [responseJSON release];
    //[ArrayMut release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.tintColor=[UIColor darkTextColor];
    
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
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    responseJSON=[[NSMutableDictionary alloc]init]; 
    ArrayMut =[[NSMutableArray alloc]init];

    responseJSON= [[str JSONValue] copy];
   
   // [[AppDelegate setvalues] setObject:str forKey:@"Rs"];
    
    self.navigationItem.title=[responseJSON objectForKey:@"username"];

    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(130,20,190,60)];
    [lbl setText:[responseJSON objectForKey:@"name"]];
    [lbl setTag:11];
    lbl.font=[UIFont systemFontOfSize:20];
    [lbl setTextColor:[UIColor blackColor]];
    [lbl setBackgroundColor:[UIColor clearColor]];
    lbl.lineBreakMode=UILineBreakModeWordWrap;
    lbl.numberOfLines=3;
    [self.view addSubview:lbl];
    //[lbl release];
    
//Showing Profile picture 
    NSString *uid = [responseJSON objectForKey:@"id"];
    NSString *str1=[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",uid];
    NSURL *imageURL = [NSURL URLWithString:str1];
    NSData *data =  [NSData dataWithContentsOfURL:imageURL];  
    UIImage *proimage = [[UIImage alloc] initWithData:data] ;
    proImg=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,110,100)];
    proImg.image=proimage;
    [self.view addSubview:proImg];

    // Creating table view    
    ProfileTable=[[UITableView alloc]initWithFrame:CGRectMake(0,100, 320,360) style:UITableViewStylePlain];
    //[ProfileTable setBackgroundColor:[UIColor ]];
    ProfileTable.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    ProfileTable.dataSource = self;
    ProfileTable.delegate = self;
    [self.view addSubview:ProfileTable];

    [super viewDidLoad];
}
//***  When clicked logout, removing username and password from cookies
-(void)Logout:(id)sender{
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookies deleteCookie:cookie];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//****** Table View Delegate methods *******//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;{    // fixed font style. use custom view (UILabel) if you want something different
    if (section==0) {
        return @"Education";

    }else if(section==1){
        return @"Work";
    }else if(section==2){
        return @"Relationship";
    }else if(section==3){
        return @"Friends";
    }else if(section==4){
        return @"Likes";
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else if(section==1){
        return 1;

    }else if(section==2||section==4){
        return 1;
    }else if(section==3){
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
       return 35;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }

    if (indexPath.section==0) {
        ArrayMut=[responseJSON objectForKey:@"education"];
        if ([ArrayMut count]>0) {
            cell.textLabel.text=[[[ArrayMut objectAtIndex:[ArrayMut count]-1] objectForKey:@"school"] objectForKey:@"name"];

        }
    }else if(indexPath.section==1){
        
        NSArray *arr1=[responseJSON objectForKey:@"work"];
     str2=[NSString stringWithFormat:@"%@.",[[[arr1 objectAtIndex:0] objectForKey:@"position"] objectForKey:@"name"]];
        cell.textLabel.text=str2;
    }else if(indexPath.section==2){
        cell.textLabel.text=[responseJSON objectForKey:@"relationship_status"];
    }else if(indexPath.section==3){

        cell.textLabel.text=@"Friends";

    }else if(indexPath.section==4){
        cell.textLabel.text=@"Likes";
    }
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
       return cell;
    
}

//**** selection of table view cell ****//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==3) {
        FriendsView *Fview=[[FriendsView alloc]init];
        Fview.indexValue=indexPath.section;
        [self.navigationController pushViewController:Fview animated:YES];
      //  [al release];
    }else if(indexPath.section==4){
        FriendsView *Lview=[[FriendsView alloc]init];
        Lview.indexValue=indexPath.section;
        [self.navigationController pushViewController:Lview animated:YES];
       // [likes release];
    }else if(indexPath.section==0){
        EducationView *eduview=[[EducationView alloc]init];
        eduview.z=indexPath.section;
        eduview.responsestring=str;
        [self.navigationController pushViewController:eduview animated:YES];
       // [eduview release];
    }else if(indexPath.section==1){
        EducationView *edviw=[[EducationView alloc]init];
        edviw.z=indexPath.section;
        edviw.responsestring=str;
        [self.navigationController pushViewController:edviw animated:YES];
       // [edviw release];
    }
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
