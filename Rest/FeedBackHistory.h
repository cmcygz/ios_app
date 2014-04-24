//
//  FeedBackHistory.h
//  Rest
//
//  Created by Malik Imran on 4/22/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"
@interface FeedBackHistory : UIViewController<UITableViewDelegate,  UITableViewDataSource>{
    __weak IBOutlet UIButton *back;
    __weak IBOutlet UIButton *home;
    NSArray *allItems;
    IBOutlet UITableView *tableView;
}
@property (nonatomic,strong)TQStarRatingView *starRatingView;
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;
@end
