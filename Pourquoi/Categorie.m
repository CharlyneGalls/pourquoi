//
//  Categorie.m
//  Pourquoi
//
//  Created by Charlyne Rivera on 06/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import "Categorie.h"

@implementation Categorie

- (id)init
{
    self = [self initWithName:@"Default" initWithImage:@"categorie-default.png"];
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
