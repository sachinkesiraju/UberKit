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
    [uberKit getProductsForLocationWithLatitude:40.727 longitude:-74.1726 success:^(NSArray *products)
     {
         NSLog(@"Product view %@", products);
     }
    failure:^(NSError *error, NSHTTPURLResponse *response)
     {
         NSLog(@"Error %@", error);
     }];
    
    [uberKit getTimeForProductArrivalWithStartLatitude:40.727 startLongitude:-74.1726 success:^(NSArray *times)
     {
         NSLog(@"Times view %@", times);
         UberTime *time = [times objectAtIndex:0];
         NSLog(@"Time %@ estimate %@", time, [[times objectAtIndex:0] valueForKey:@"estimate"]);
     }
    failure:^(NSError *error, NSHTTPURLResponse *response)
     {
         NSLog(@"Error %@", error);
     }];
    
    [uberKit getPriceForTripWithStartLatitude:40.725 startLongitude:-74.1726 endLatitude:41.0 endLongitude:-75.0 success:^(NSArray *prices)
     {
         NSLog(@"Prices view %@", prices);
         UberPrice *price = [prices objectAtIndex:0];
         NSLog(@"Price %@", price.estimate);
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
