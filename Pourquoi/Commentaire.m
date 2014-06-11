//
//  Commentaire.m
//  Pourquoi
//
//  Created by Charlyne Rivera on 12/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import "Commentaire.h"

@implementation Commentaire

- (id)init
{
    self = [self initWithName:@"default"
                initWithImage:@"user-photo.jpg"
              initWithMessage:@"default message"
                 initWithDate:[NSDate date]];
    return self;
}

- (id)initWithName:(NSString *)aName
     initWithImage:(NSString *)anImageFile
   initWithMessage:(NSString *)aMessage
      initWithDate:(NSDate *)aDate
{
    self = [super init];
    if (self) {
        self.name = aName;
        self.imageFile = anImageFile;
        self.message = aMessage;
        self.date = aDate;
    }
    return self;
}

@end
