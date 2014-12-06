//
//  UberPromotion.h
//  UberKitDemo
//
//  Created by Sachin Kesiraju on 12/6/14.
//  Copyright (c) 2014 Sachin Kesiraju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UberPromotion : NSObject

@property (nonatomic) NSString *text;
@property (nonatomic) NSString *localized_value;
@property (nonatomic) NSString *type;

- (instancetype) initWithDictionary: (NSDictionary *) dictionary;

@end
