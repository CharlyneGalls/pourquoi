//
//  UserCustomCell.m
//  Pourquoi
//
//  Created by Charlyne Rivera on 14/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import "UserCustomCell.h"

@implementation UserCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)debugQuickLookObject
{
    NSAttributedString *cr = [[NSAttributedString alloc] initWithString:@"\n"];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithAttributedString:self.definitionCell.attributedText];
    [result appendAttributedString:cr];
    [result appendAttributedString:self.textCell.attributedText];
    return result;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView layoutIfNeeded];
    self.textCell.preferredMaxLayoutWidth = CGRectGetWidth(self.textCell.frame);
}

@end
