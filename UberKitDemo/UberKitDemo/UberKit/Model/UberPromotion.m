//
//  UberPromotion.m
//  UberKitDemo
//
//  Created by Sachin Kesiraju on 12/6/14.
//  Copyright (c) 2014 Sachin Kesiraju. All rights reserved.
//

#import "UberPromotion.h"

@implementation UberPromotion

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        _text = [dictionary objectForKey:@"display_text"];
        _localized_value = [dictionary objectForKey:@"localized_value"];
        _type = [dictionary objectForKey:@"type"];
    }
    return self;
}

@end
