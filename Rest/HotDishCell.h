//
//  HotDishCell.h
//  Food
//
//  Created by Malik Imran on 3/24/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotDishCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImageHotDish;
@property (weak, nonatomic) IBOutlet UILabel *lableTitle;
@property (weak, nonatomic) IBOutlet UILabel *lablePrice;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;

@end
