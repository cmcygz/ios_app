//
//  RunningOrder.h
//  Rest
//
//  Created by Malik Imran on 4/23/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfiniTabBar.h"
@interface RunningOrder : UIViewController<UITableViewDelegate,  UITableViewDataSource, InfiniTabBarDelegate>{
    InfiniTabBar *tabBar;
    __weak IBOutlet UIButton *back;
    __weak IBOutlet UIButton *home;
    IBOutlet UITableView *tableView;
    NSArray *allItems;
    NSArray *allOrderId;
    NSArray *total_rows;
    NSArray *order_history;
    NSArray *order_id;
    NSArray *dish_img;
}
@property (nonatomic, retain) InfiniTabBar *tabBar;
@property (nonatomic, weak) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *home;
@end
