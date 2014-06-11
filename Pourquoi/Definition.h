//
//  Definition.h
//  Pourquoi
//
//  Created by Charlyne Rivera on 06/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Definition : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) PFFile *imageFile;
@property (strong, nonatomic) NSString *categorie;
@property (strong, nonatomic) NSArray *explications;
@property (strong, nonatomic) NSMutableArray *commentaires;

@end
