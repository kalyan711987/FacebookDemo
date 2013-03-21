//
//  ViewController.m
//  DemoFB
//
//  Created by sathish kumar on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    
}
- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *fbbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [fbbtn setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
    [fbbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [fbbtn setTag:10];
    [self.view addSubview:fbbtn];
    fbbtn.frame=CGRectMake(60, 150, 200, 160);
    [fbbtn addTarget:self action:@selector(Signin) forControlEvents:UIControlEventTouchUpInside];
    Redirect=YES;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)Signin{
    
    alert= [[UIAlertView alloc] initWithTitle:@"Loading....." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] ;
    [alert show];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    activityIndicator.center = CGPointMake( 140,  65);
    [activityIndicator startAnimating];
    [alert addSubview:activityIndicator];
    
    NSDictionary *options = @{
     ACFacebookAppIdKey: @"312835692060133",
     ACFacebookPermissionsKey:  @[@"email", @"read_friendlists",@"user_birthday",@"user_likes",@"user_relationships",@"publish_stream"],
   ACFacebookAudienceKey: ACFacebookAudienceFriends
    };

    appdell=(AppDelegate*)[UIApplication sharedApplication].delegate;
    appdell.accountStore=nil;
    appdell.facebookAccount=nil;
    if(!appdell.accountStore)
        appdell.accountStore = [[ACAccountStore alloc] init];
   
    ACAccountType *facebookTypeAccount = [appdell.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [appdell.accountStore requestAccessToAccountsWithType:facebookTypeAccount
                                           options:options
                                        completion:^(BOOL granted, NSError *error) {
                                            if(granted){
                                                NSArray *accounts = [appdell.accountStore accountsWithAccountType:facebookTypeAccount];
                                                appdell.facebookAccount = [accounts lastObject];
                                                NSLog(@"Success %@",appdell.facebookAccount);
                                                
                                                [self me];
                                            }else{
                                                // ouch
                                                [alert dismissWithClickedButtonIndex:0 animated:YES];

                                                if([error code]==6)
                                                    [self alertview:@"Error" messsage:@"Account not found. Please setup your account in settings app." tag:0];
                                                else
                                                    [self alertview:@"Error" messsage:@"Account access denied." tag:0];
                                                NSLog(@"Error: %@", error);
                                            }
                                        }];
}


- (void)me{
    NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                              requestMethod:SLRequestMethodGET
                                                        URL:meurl
                                                 parameters:nil];
    
    merequest.account =appdell.facebookAccount;
    
    [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];

        NSString *meDataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *responceJson=[meDataString JSONValue];
        NSLog(@"%@", responceJson);
        ProfileInfoView *proview=[[ProfileInfoView alloc]init];
        proview.str=meDataString;
        [self.navigationController pushViewController:proview animated:YES];
    }];
    
}
// Web view delegate methods


-(UIAlertView*)alertview:(NSString*)title messsage:(NSString*)msg tag:(int)tagvalue{
    
    UIAlertView *alerta=[[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alerta.tag=tagvalue;
    [alerta show];
    return alerta;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
