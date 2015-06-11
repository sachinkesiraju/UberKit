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

NSString * const baseURL = @"https://api.uber.com/v1";
NSString * const mobile_safari_string = @"com.apple.mobilesafari";

@interface UberKit()

@property (strong, nonatomic) NSString *accessToken;

@end

@interface UberKit (Private)

- (void) performNetworkOperationWithURL: (NSString *) url
                         completionHandler: (void (^)(NSDictionary *, NSURLResponse *, NSError *)) completion;
@end

@implementation UberKit

#pragma mark - Initialization

+ (UberKit *) sharedInstance
{
    static UberKit *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype) initWithServerToken:(NSString *)serverToken
{
    self = [super init];
    if(self)
    {
        _serverToken = serverToken;
    }
    
    return self;
}

- (instancetype) initWithClientID:(NSString *)clientId ClientSecret:(NSString *)clientSecret RedirectURL:(NSString *)redirectURL ApplicationName:(NSString *)applicationName
{
    self = [super init];
    if(self)
    {
        _clientID = clientId;
        _clientSecret = clientSecret;
        _redirectURL = redirectURL;
        _applicationName = applicationName;
    }
    
    return self;
}

#pragma mark - Login

- (void) startLogin
{
    [self setupOAuth2AccountStore];
    [self requestOAuth2Access];
}

- (NSString *) getStoredAuthToken
{
    return _accessToken;
}

#pragma mark - Product Types

- (void) getProductsForLocation:(CLLocation *)location withCompletionHandler:(CompletionHandler)completion
{
    // GET/v1/products
    
    NSString *url = [NSString stringWithFormat:@"%@/products?server_token=%@&latitude=%f&longitude=%f", baseURL, _serverToken, location.coordinate.latitude, location.coordinate.longitude];
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
    
    NSString *url = [NSString stringWithFormat:@"%@/estimates/price?server_token=%@&start_latitude=%f&start_longitude=%f&end_latitude=%f&end_longitude=%f", baseURL, _serverToken, startLocation.coordinate.latitude, startLocation.coordinate.longitude, endLocation.coordinate.latitude, endLocation.coordinate.longitude];
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
    
    NSString *url = [NSString stringWithFormat:@"%@/estimates/time?server_token=%@&start_latitude=%f&start_longitude=%f", baseURL, _serverToken, location.coordinate.latitude, location.coordinate.longitude];
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

#pragma mark - Promotion Estimates

- (void) getPromotionForLocation:(CLLocation *)startLocation endLocation:(CLLocation *)endLocation withCompletionHandler:(PromotionHandler)handler
{
    NSString *url = [NSString stringWithFormat:@"%@/promotions?server_token=%@&start_latitude=%f&start_longitude=%f&end_latitude=%f&end_longitude=%f", baseURL, _serverToken, startLocation.coordinate.latitude, startLocation.coordinate.longitude, endLocation.coordinate.latitude, endLocation.coordinate.longitude];
    [self performNetworkOperationWithURL:url completionHandler:^(NSDictionary *promotionDictionary, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             UberPromotion *promotion = [[UberPromotion alloc] initWithDictionary:promotionDictionary];
             handler(promotion, response, error);
         }
         else
         {
             handler(nil, response, error);
         }
     }];
}

#pragma mark - User History

- (void) getUserActivityWithCompletionHandler:(CompletionHandler)completion
{
    //GET /v1.1/history
    
    NSString *url = [NSString stringWithFormat:@"https://api.uber.com/v1.1/history?access_token=%@", _accessToken];
    [self performNetworkOperationWithURL:url completionHandler:^(NSDictionary *activity, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             int offset = [[activity objectForKey:@"offset"] intValue];
             int limit = [[activity objectForKey:@"limit"] intValue];
             int count = [[activity objectForKey:@"count"] intValue];
             NSArray *history = [activity objectForKey:@"history"];
             NSMutableArray *availableActivity = [[NSMutableArray alloc] init];
             for(int i=0; i<history.count; i++)
             {
                 UberActivity *activity = [[UberActivity alloc] initWithDictionary:[history objectAtIndex:i]];
                 [activity setLimit:limit];
                 [activity setOffset:offset];
                 [activity setCount:count];
                 [availableActivity addObject:activity];
             }
             completion(availableActivity, response, error);
         }
         else
         {
             completion(nil, response, error);
         }
     }];
}

#pragma mark - User Profile

- (void) getUserProfileWithCompletionHandler:(ProfileHandler)handler
{
    //GET /v1/me
    
    NSString *url = [NSString stringWithFormat:@"%@/me?access_token=%@", baseURL, _accessToken];
    [self performNetworkOperationWithURL:url completionHandler:^(NSDictionary *profileDictionary, NSURLResponse *response, NSError *error)
     {
         if(profileDictionary)
         {
             UberProfile *profile = [[UberProfile alloc] initWithDictionary:profileDictionary];
             handler(profile, response, error);
         }
         else
         {
             handler(nil, response, error);
         }
     }];
}

#pragma mark - Login flow

- (BOOL) handleLoginRedirectFromUrl:(NSURL *)url sourceApplication:(NSString *)sourceApplication
{
    if ([sourceApplication isEqualToString:mobile_safari_string] && [url.absoluteURL.host hasPrefix:_redirectURL])
    {
        NSString *code = nil;
        NSArray *urlParams = [[url query] componentsSeparatedByString:@"&"];
        for (NSString *param in urlParams) {
            NSArray *keyValue = [param componentsSeparatedByString:@"="];
            NSString *key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"code"])
            {
                code = [keyValue objectAtIndex:1]; //retrieving the code
                NSLog(@"%@", code);
            }
            if (code)
            {
                //Got the code, now retrieving the auth token
                [self getAuthTokenForCode:code];
            }
            else
            {
                NSLog(@"There was an error returning from mobile safari");
            }
            
            return NO;
        }
    }
    
    return YES;
}

- (void) getAuthTokenForCode: (NSString *) code
{
    NSString *data = [NSString stringWithFormat:@"code=%@&client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code", code, _clientID, _clientSecret, _redirectURL];
    NSString *url = [NSString stringWithFormat:@"https://login.uber.com/oauth/token"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *authData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(!error)
    {
        NSError *jsonError = nil;
        NSDictionary *authDictionary = [NSJSONSerialization JSONObjectWithData:authData options:0 error:&jsonError];
        if(!jsonError)
        {
            _accessToken = [authDictionary objectForKey:@"access_token"];
            if(_accessToken)
            {
                if([self.delegate respondsToSelector:@selector(uberKit:didReceiveAccessToken:)])
                {
                    [self.delegate uberKit:self didReceiveAccessToken:_accessToken];
                }
            }
        }
        else
        {
            NSLog(@"Error retrieving access token %@", jsonError);
        }
    }
    else
    {
        NSLog(@"Error in sending request for access token %@", error);
    }
}

#pragma mark - OAuth

- (void)setupOAuth2AccountStore
{
    [[NXOAuth2AccountStore sharedStore] setClientID:_clientID
                                             secret:_clientSecret
                                   authorizationURL:[NSURL URLWithString:@"https://login.uber.com/oauth/authorize"]
                                           tokenURL:[NSURL URLWithString:@"https://login.uber.com/oauth/token"]
                                        redirectURL:[NSURL URLWithString:_redirectURL]
                                     forAccountType:_applicationName];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      
                                                      if (aNotification.userInfo){
                                                          NSLog(@"Success! Received access token");
                                                      }
                                                      else{
                                                          NSLog(@"Account removed, lost access");
                                                      }
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      
                                                      NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
                                                      NSLog(@"Error! %@", error.localizedDescription);
                                                      
                                                  }];
}

-(void)requestOAuth2Access
{
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:_applicationName
                                   withPreparedAuthorizationURLHandler:^(NSURL *preparedURL){

                                       [[UIApplication sharedApplication] openURL:preparedURL];
                                       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
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
