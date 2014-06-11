//
//  User.h
//  Pourquoi
//
//  Created by Charlyne Rivera on 13/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageFile;
@property (strong, nonatomic) NSMutableArray *commentaires;

- (id)initWithName:(NSString *)aName
     initWithImage:(NSString *)anImageFile;

@end