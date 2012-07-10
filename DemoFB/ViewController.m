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
    NSString *appId = @"200273063433244";
    NSString *permissions = @"publish_stream,user_birthday,read_friendlists,user_relationships,user_likes";
   
    webview =[[UIWebView alloc]initWithFrame:CGRectMake(10, 10, 300, 430)];
    webview.scalesPageToFit=YES;
    webview.layer.cornerRadius = 6;
    webview.layer.borderColor = [UIColor blackColor].CGColor;
    webview.layer.borderWidth = 1;   
    webview.delegate=self;
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                UIActivityIndicatorViewStyleGray];
    _spinner.center=CGPointMake(160, 240);
    [webview addSubview:_spinner];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(279,-7,28, 28);
    [btn setImage:[UIImage imageNamed:@"close@2x.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [webview addSubview:btn];
    NSString *redirectUrlString = @"http://www.facebook.com/connect/login_success.html";
    NSString *authFormatString = @"https://graph.facebook.com/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@&type=user_agent&display=touch";
    
    NSString *urlString = [NSString stringWithFormat:authFormatString, appId, redirectUrlString, permissions];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webview loadRequest:request];	   
    [self.view addSubview:webview];
    
    // amimations to show a webview
    CABasicAnimation *scaoleAnimation  = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.duration = 0.5;
    scaoleAnimation.autoreverses = NO;
    scaoleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaoleAnimation.toValue = [NSNumber numberWithFloat:1.5];
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.autoreverses = NO;
    group.duration = 1.0;
    group.animations = [NSArray arrayWithObjects: scaoleAnimation, nil];        
    [webview.layer addAnimation:group forKey:@"stop"];
    
    
}

-(void)close:(id)sender{
    
    webview.hidden=YES;
}

// Web view delegate methods
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    webview.hidden=YES;
    
    [_spinner stopAnimating];
    if (Redirect) {
        [self Signin];

    }
        
}
- (void)webViewDidStartLoad:(UIWebView *)webView { 
    
    [_spinner startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [_spinner stopAnimating];
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = request.URL.absoluteString;
    
    [self checkForAccessToken:urlString]; 
    
    
    return TRUE;
}
// Getting the access token of facebook and storing in nsuserdefaults
-(void)checkForAccessToken:(NSString *)urlString {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"access_token=(.*)&" options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        // NSLog(@" before token ");
        if (firstMatch) {
            NSRange accessTokenRange = [firstMatch rangeAtIndex:1];
            NSString *accessToken = [urlString substringWithRange:accessTokenRange];
            accessToken = [accessToken stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            // NSLog(@" aftr token ");
            
            if ([accessToken length]>0) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:accessToken forKey:@"Token"];
                //  NSLog(@" Getting profile ");
                
                [self getfacebookprofile];
            }        }
    }
}
// Fetching facebook details with the access token
-(void)getfacebookprofile
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *_accessToken=[defaults objectForKey:@"Token"];
    
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@", [_accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   // NSURL *url = [NSURL URLWithString:urlString];
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
    else
    {
        // The download could not be made.
        NSLog( @"Data could not be received from: %@", request.URL );
    }
    
    // PROBLEM - receivedString is NULL here.
   // NSLog( @"From getContentURL: %@", postdata);

    
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
   // NSMutableDictionary *responseJSON = [loginStatus JSONValue];
    NSMutableDictionary *responceJson=[loginStatus JSONValue];
    NSString *uid = [responceJson objectForKey:@"id"];
    Redirect=YES;
    webview.hidden=YES;

    if ([uid length]>0 && Redirect) {
        
    ProfileInfoView *proview=[[ProfileInfoView alloc]init];
    proview.str=loginStatus;
    [self.navigationController pushViewController:proview animated:YES];
        Redirect=NO;
    }
   // [proview release];

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
