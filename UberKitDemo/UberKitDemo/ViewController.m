//
//  ViewController.m
//  UberKitDemo
//
//  Created by Sachin Kesiraju on 8/21/14.
//  Copyright (c) 2014 Sachin Kesiraju. All rights reserved.
//

#import "ViewController.h"
#import "UberKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UberKit *uberKit = [[UberKit alloc] initWithServerToken:@"YOUR_SERVER_TOKEN"]; //Add your server token
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performActionsWithToken) name:@"Token available" object:nil];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:37.7833 longitude:-122.4167];
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:37.9 longitude:-122.43];
    
    [uberKit getProductsForLocation:location withCompletionHandler:^(NSArray *products, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             UberProduct *product = [products objectAtIndex:0];
             NSLog(@"Product name of first %@", product.product_description);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
    
    [uberKit getTimeForProductArrivalWithLocation:location withCompletionHandler:^(NSArray *times, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             UberTime *time = [times objectAtIndex:0];
             NSLog(@"Time for first %f", time.estimate);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
    
    [uberKit getPriceForTripWithStartLocation:location endLocation:endLocation  withCompletionHandler:^(NSArray *prices, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             UberPrice *price = [prices objectAtIndex:0];
             NSLog(@"Price for first %@", price.estimate);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
}

- (IBAction)login:(id)sender
{
    [[UberKit sharedInstance] setClientID:@"YOUR_CLIENT_ID"]; //Add your client id
    [[UberKit sharedInstance] setClientSecret:@"YOUR_CLIENT_SECRET"]; //Add your client secret
    [[UberKit sharedInstance] setRedirectURL:@"YOUR_REDIRECT_URL"]; //Add your redirect url
    [[UberKit sharedInstance] setApplicationName:@"YOUR_APPLICATION_NAME"]; //Add your application name
    [[UberKit sharedInstance] startLogin];
    
    //UberKit *uberKit = [[UberKit alloc] initWithClientID:@"YOUR_CLIENT_ID" ClientSecret:@"YOUR_CLIENT_SECRET" RedirectURL:@"YOUR_REDIRECT_URL" ApplicationName:@"YOUR_APPLICATION_NAME"];  // Alternate initialization
}

- (void) performActionsWithToken
{
    NSString *authToken = [[UberKit sharedInstance] getStoredAuthToken];
    if(authToken)
    {
        [[UberKit sharedInstance] getUserActivityWithCompletionHandler:^(NSArray *activities, NSURLResponse *response, NSError *error)
         {
             if(!error)
             {
                 NSLog(@"User activity %@", activities);
                 UberActivity *activity = [activities objectAtIndex:0];
                 NSLog(@"Last trip distance %f", activity.distance);
             }
             else
             {
                 NSLog(@"Error %@", error);
             }
         }];
        
        [[UberKit sharedInstance] getUserProfileWithCompletionHandler:^(UberProfile *profile, NSURLResponse *response, NSError *error)
         {
             if(!error)
             {
                 NSLog(@"User's full name %@ %@", profile.first_name, profile.last_name);
             }
             else
             {
                 NSLog(@"Error %@", error);
             }
         }];
    }
    else
    {
        NSLog(@"No auth token yo, try again");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
