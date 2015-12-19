//
//  ViewController.m
//  UberKitDemo
//
//  Created by Sachin Kesiraju on 8/21/14.
//  Copyright (c) 2014 Sachin Kesiraju. All rights reserved.
//

#import "ViewController.h"

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
    [self callClientAuthenticationMethods];
}

- (void) callClientAuthenticationMethods
{
    UberKit *uberKit = [[UberKit alloc] initWithServerToken:@"YOUR_SERVER_TOKEN"]; //Add your server token
    //[[UberKit sharedInstance] setServerToken:@"YOUR_SERVER_TOKEN"]; //Alternate initialization
    
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
             NSLog(@"Price for first %i", price.lowEstimate);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
    
    [uberKit getPromotionForLocation:location endLocation:endLocation withCompletionHandler:^(UberPromotion *promotion, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             NSLog(@"Promotion - %@", promotion.localized_value);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
}

- (IBAction)login:(id)sender
{
    [[UberKit sharedInstance] setClientID:@"YOUR_CLIENTID"];
    [[UberKit sharedInstance] setClientSecret:@"YOUR_CLIENT_SECRET"];
    [[UberKit sharedInstance] setRedirectURL:@"YOUR_REDIRECT_URI"];
    [[UberKit sharedInstance] setApplicationName:@"YOUR_APPLICATION_NAME"];
    //UberKit *uberKit = [[UberKit alloc] initWithClientID:@"YOUR_CLIENTID" ClientSecret:@"YOUR_CLIENT_SECRET" RedirectURL:@"YOUR_REDIRECT_URI" ApplicationName:@"YOUR_APPLICATION_NAME"]; // Alternate initialization
    UberKit *uberKit = [UberKit sharedInstance];
    uberKit.delegate = self;
    [uberKit startLogin];
}

- (void) uberKit:(UberKit *)uberKit didReceiveAccessToken:(NSString *)accessToken
{
    NSLog(@"Received access token %@", accessToken);
    if(accessToken)
    {
        [uberKit getUserActivityWithCompletionHandler:^(NSArray *activities, NSURLResponse *response, NSError *error)
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
        
        [uberKit getUserProfileWithCompletionHandler:^(UberProfile *profile, NSURLResponse *response, NSError *error)
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
        NSLog(@"No auth token, try again");
    }
}

- (void) uberKit:(UberKit *)uberKit loginFailedWithError:(NSError *)error
{
    NSLog(@"Error in login %@", error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
