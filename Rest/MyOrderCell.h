//
//  MyOrderCell.h
//  Food
//
//  Created by Malik Imran on 3/27/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *ImageOrderMenu;
@property (strong, nonatomic) IBOutlet UILabel *LableOrderMenu;
@property (weak, nonatomic) IBOutlet UILabel *lablePriceOrderMenu;
@property (weak, nonatomic) IBOutlet UIButton *buttonSubtractOrder;

@end
