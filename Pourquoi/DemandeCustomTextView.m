//
//  DemandeCustomTextView.m
//  Pourquoi
//
//  Created by Charlyne Rivera on 09/06/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import "DemandeCustomTextView.h"

@implementation DemandeCustomTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.size.height = 20;
    return originalRect;
}

@end
