//
//  User.m
//  Pourquoi
//
//  Created by Charlyne Rivera on 13/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)init
{
    self = [self initWithName:@"Default" initWithImage:@"user-photo.jpg"];
    return self;
}

- (id)initWithName:(NSString *)aName
     initWithImage:(NSString *)anImageFile
{
    self = [super init];
    if (self) {
        self.name = aName;
        self.imageFile = anImageFile;
    }
    return self;
}

@end