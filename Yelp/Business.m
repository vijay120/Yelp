//
//  Business.m
//  Yelp
//
//  Created by Vijay Ramakrishnan on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business


-(id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        NSArray *categories = dictionary[@"categories"];
        NSMutableArray *categoryNames =[NSMutableArray array];
        [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [categoryNames addObject:obj[0]];
        }];
        self.categories = [categoryNames componentsJoinedByString:@", "];
        self.name = dictionary[@"name"];
        self.imageUrl = dictionary[@"image_url"];
        
        NSString *street;
        NSString *neighborhood;
        
        if ([dictionary[@"location"][@"address"] count] > 0) {
            street = [dictionary valueForKeyPath:@"location.address"][0];
        } else {
            street = @"Address not found";
        }
        
        if ([dictionary[@"location"][@"neighborhoods"] count] > 0) {
            neighborhood = [dictionary valueForKeyPath:@"location.neighborhoods"][0];
        } else {
            neighborhood = @"Neighborhood not found";
        }
        
        self.address = [NSString stringWithFormat:@"%@, %@", street, neighborhood];
        self.numReviews = [dictionary[@"review_count"] integerValue];
        self.ratingImageUrl = dictionary[@"rating_img_url"];
        float milesPerMeter = 0.000621371;
        self.distance = [dictionary[@"distance"] integerValue] * milesPerMeter;
    }

    return self;
}

+ (NSArray *) businessesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *businesses = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Business *business = [[Business alloc] initWithDictionary:dictionary];
        [businesses addObject:business];
    }
    return businesses;
}




@end
