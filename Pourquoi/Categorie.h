//
//  Categorie.h
//  Pourquoi
//
//  Created by Charlyne Rivera on 06/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categorie : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageFile;

- (id)initWithName:(NSString *)aName
     initWithImage:(NSString *)anImageFile;

@end
