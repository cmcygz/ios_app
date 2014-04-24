//
//  HistoryCell.h
//  Rest
//
//  Created by Malik Imran on 4/22/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *starView;
@property (strong, nonatomic) IBOutlet UILabel *lableDate;

@property (strong, nonatomic) IBOutlet UILabel *lableRemarks;
@end
