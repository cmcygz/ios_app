//
//  HomeMenuCell.m
//  Food
//
//  Created by Malik Imran on 3/23/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import "HomeMenuCell.h"

@implementation HomeMenuCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.cellItemImageView.image = nil;
        self.LableHomeMenu.text = nil;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
