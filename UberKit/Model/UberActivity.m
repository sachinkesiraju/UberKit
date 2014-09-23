//
//  UberActivity.m
//  UberKitDemo
//
//  Created by Sachin Kesiraju on 9/21/14.
//  Copyright (c) 2014 Sachin Kesiraju. All rights reserved.
//

#import "UberActivity.h"

@implementation UberActivity

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        _uiud = [dictionary objectForKey:@"uiud"];
        _product_id = [dictionary objectForKey:@"product_id"];
        _status = [dictionary objectForKey:@"status"];
        _distance = [[dictionary objectForKey:@"distance"] floatValue];
        _request_time = [[dictionary objectForKey:@"request_time"] intValue];
        _start_time = [[dictionary objectForKey:@"start_time"] intValue];
        _end_time = [[dictionary objectForKey:@"end_time"] intValue];
    }
    return self;
}

@end
