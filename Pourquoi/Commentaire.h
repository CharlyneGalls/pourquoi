//
//  Commentaire.h
//  Pourquoi
//
//  Created by Charlyne Rivera on 12/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commentaire : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageFile;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDate *date;

- (id)initWithName:(NSString *)aName
     initWithImage:(NSString *)anImageFile
   initWithMessage:(NSString *)aMessage
      initWithDate:(NSDate *)aDate;

@end
