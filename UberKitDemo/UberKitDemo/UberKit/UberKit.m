//
//  UberKit.m
//  UberKit
//
// Created by Sachin Kesiraju on 8/20/14.
// Copyright (c) 2014 Sachin Kesiraju
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "UberKit.h"

static const NSString *baseURL = @"https://api.uber.com";

@interface UberKit (Private)

- (void) performNetworkOperationWithURL: (NSString *) url
                         completionHandler: (void (^)(NSDictionary *, NSURLResponse *, NSError *)) completion;
@end

@implementation UberKit

- (instancetype) initWithServerToken:(NSString *)serverToken
{
    self = [super init];
    if(self)
    {
        _serverToken = serverToken;
    }
    
    return self;
}

#pragma mark - Product Types

- (void) getProductsForLocation:(CLLocation *)location withCompletionHandler:(CompletionHandler)completion
{
    // GET/v1/products
    
    NSString *url = [NSString stringWithFormat:@"%@/v1/products?server_token=%@&latitude=%f&longitude=%f", baseURL, _serverToken, location.coordinate.latitude, location.coordinate.longitude];
    [self performNetworkOperationWithURL:url completionHandler:^(NSDictionary *results, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             NSArray *products = [results objectForKey:@"products"];
             NSMutableArray *availableProducts = [[NSMutableArray alloc] init];
             for(int i=0; i<products.count; i++)
             {
                 UberProduct *product = [[UberProduct alloc] initWithDictionary:[products objectAtIndex:i]];
                 [availableProducts addObject:product];
             }
             completion(availableProducts, response, error);
         }
         else
         {
             NSLog(@"Error %@", error);
             completion(nil, response, error);
         }
     }];
}

#pragma mark - Price Estimates

- (void) getPriceForTripWithStartLocation:(CLLocation *)startLocation endLocation:(CLLocation *)endLocation withCompletionHandler:(CompletionHandler)completion
{
    // GET /v1/estimates/price
    
    NSString *url = [NSString stringWithFormat:@"%@/v1/estimates/price?server_token=%@&start_latitude=%f&start_longitude=%f&end_latitude=%f&end_longitude=%f", baseURL, _serverToken, startLocation.coordinate.latitude, startLocation.coordinate.longitude, endLocation.coordinate.latitude, endLocation.coordinate.longitude];
    [self performNetworkOperationWithURL:url completionHandler:^(NSDictionary *results, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             NSArray *prices = [results objectForKey:@"prices"];
             NSMutableArray *availablePrices = [[NSMutableArray alloc] init];
             for(int i=0; i<prices.count; i++)
             {
                 UberPrice *price = [[UberPrice alloc] initWithDictionary:[prices objectAtIndex:i]];
                 if(price.lowEstimate > -1)
                 {
                     [availablePrices addObject:price];
                 }
             }
             completion(availablePrices, response, error);
         }
         else
         {
             NSLog(@"Error %@", error);
             completion(nil, response, error);
         }
     }];
}

#pragma mark - Time Estimates

- (void) getTimeForProductArrivalWithLocation:(CLLocation *)location withCompletionHandler:(CompletionHandler)completion
{
    //GET /v1/estimates/time
    
    NSString *url = [NSString stringWithFormat:@"%@/v1/estimates/time?server_token=%@&start_latitude=%f&start_longitude=%f", baseURL, _serverToken, location.coordinate.latitude, location.coordinate.longitude];
    [self performNetworkOperationWithURL:url completionHandler:^(NSDictionary *results, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             NSArray *times = [results objectForKey:@"times"];
             NSMutableArray *availableTimes = [[NSMutableArray alloc] init];
             for(int i=0; i<times.count; i++)
             {
                 UberTime *time = [[UberTime alloc] initWithDictionary:[times objectAtIndex:i]];
                 [availableTimes addObject:time];
             }
             completion(availableTimes, response, error);
         }
         else
         {
             NSLog(@"Error %@", error);
             completion(nil, response, error);
         }
     }];
}

#pragma mark - Deep Linking

- (void) openUberApp
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uber://"]])
    {
        //Uber is installed
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"uber://"]];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://uber.com"]];
    }
}

@end

@implementation UberKit (Private)

- (void) performNetworkOperationWithURL:(NSString *)url completionHandler:(void (^)(NSDictionary *, NSURLResponse *, NSError *))completion
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    [[session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {

            NSError *jsonError = nil;
            NSDictionary *serializedResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (jsonError == nil) {
                completion(serializedResults, response, jsonError);
            } else {
                NSHTTPURLResponse *convertedResponse = (NSHTTPURLResponse *)response;
                completion(nil, convertedResponse, jsonError);
            }
        }
        else
        {
            NSHTTPURLResponse *convertedResponse = (NSHTTPURLResponse *)response;
            completion(nil, convertedResponse, error);
        }
    }] resume];
}

@end
