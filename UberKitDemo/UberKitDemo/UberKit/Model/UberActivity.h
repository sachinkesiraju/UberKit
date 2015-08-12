//
//  UberActivity.h
//  UberKitDemo
//
//  Created by Sachin Kesiraju on 9/21/14.
//  Copyright (c) 2014 Sachin Kesiraju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UberActivity : NSObject

@property (nonatomic) int offset;
@property (nonatomic) int limit;
@property (nonatomic) int count;
@property (nonatomic) NSString *request_id;
@property (nonatomic) NSString *currency_code;
@property (nonatomic) NSString *product_id;
@property (nonatomic) NSString *status;
@property (nonatomic) int request_time;
@property (nonatomic) float distance;
@property (nonatomic) int start_time;
@property (nonatomic) int end_time;
@property (nonatomic) NSDictionary *start_city;

- (instancetype) initWithDictionary: (NSDictionary *) dictionary;

@end
