//
//  UberProfile.h
//  UberKitDemo
//
//  Created by Sachin Kesiraju on 9/21/14.
//  Copyright (c) 2014 Sachin Kesiraju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UberProfile : NSObject

@property (nonatomic) NSString *first_name;
@property (nonatomic) NSString *last_name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *picture;
@property (nonatomic) NSString *promo_code;
@property (nonatomic) NSString *uuid;

- (instancetype) initWithDictionary: (NSDictionary *) dictionary;

@end
