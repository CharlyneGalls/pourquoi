//
//  NSDate+NVTimeAgo.h
//  Pourquoi
//
//  Created by Charlyne Rivera on 06/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NVFacebookTimeAgo)

+ (NSString*)mysqlDatetimeFormattedAsTimeAgo:(NSString *)mysqlDatetime;

- (NSString *)formattedAsTimeAgo;

@end
