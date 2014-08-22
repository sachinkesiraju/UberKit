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
    
    UberKit *uberKit = [[UberKit alloc] init];
    [uberKit getProductsForLocationWithLatitude:37.7833 longitude: -122.4167 success:^(NSArray *products)
     {
         NSLog(@"Products %@", products);
         UberProduct *product = [products objectAtIndex:0];
         NSLog(@"Product name of first %@", product.description);
     }
    failure:^(NSError *error, NSHTTPURLResponse *response)
     {
         NSLog(@"Error %@", error);
     }];
    
    [uberKit getTimeForProductArrivalWithStartLatitude:37.7833 startLongitude: -122.4167 success:^(NSArray *times)
     {
         NSLog(@"Times %@", times);
         UberTime *time = [times objectAtIndex:0];
         NSLog(@"Time for first %f", time.estimate);
     }
    failure:^(NSError *error, NSHTTPURLResponse *response)
     {
         NSLog(@"Error %@", error);
     }];
    
    [uberKit getPriceForTripWithStartLatitude:37.7833 startLongitude: -122.4167 endLatitude:37.7 endLongitude: -122.42 success:^(NSArray *prices)
     {
         NSLog(@"Prices %@", prices);
         UberPrice *price = [prices objectAtIndex:0];
         NSLog(@"Price for first %@", price.estimate);
     }
    failure:^(NSError *error, NSHTTPURLResponse *response)
     {
         NSLog(@"Error %@", error);
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
