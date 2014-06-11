//
//  CommentaireCustomCell.h
//  Pourquoi
//
//  Created by Charlyne Rivera on 12/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentaireCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageCell;
@property (weak, nonatomic) IBOutlet UILabel *labelCell;
@property (weak, nonatomic) IBOutlet UILabel *textCell;
@property (weak, nonatomic) IBOutlet UILabel *dateCell;

@end
