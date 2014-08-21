//
//  UberKit.h
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

#import <Foundation/Foundation.h>

#import "UberProduct.h"
#import "UberPrice.h"
#import "UberTime.h"

typedef void (^SuccessHandler) (NSArray *resultsArray);
typedef void (^FailureHandler) (NSError *error, NSHTTPURLResponse *response);

@interface UberKit : NSObject

#pragma mark - Product Types

- (void) getProductsForLocationWithLatitude: (float) latitude longitude: (float) longitude
                                    success:(void (^) (UberProduct *))success
                                    failure:(FailureHandler)failure;
#pragma mark - Price Estimates

- (void) getPriceForTripWithStartLatitude: (float) startLatitude startLongitude: (float) startLongitude endLatitude: (float) endLatitude endLongitude: (float) endLongitude
                                  success:(void (^) (UberPrice *))success
                                  failure:(FailureHandler)failure;
#pragma mark - Time Estimates

- (void) getTimeForProductArrivalWithStartLatitude: (float) startLatitude startLongitude: (float) startLongitude
                                           success:(void (^) (UberTime *))success
                                           failure:(FailureHandler)failure;

#pragma mark - Deep Linking

- (void) openUberApp;

@end
