//
//  MyOrder.h
//  Food
//
//  Created by Malik Imran on 3/26/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLTableAlert;
#import "InfiniTabBar.h"

@interface MyOrder : UIViewController <UITableViewDelegate,  UITableViewDataSource, UISearchBarDelegate, UIAlertViewDelegate, InfiniTabBarDelegate> {
	InfiniTabBar *tabBar;
	
	// UI
	UILabel *dLabel;
	UILabel *fLabel;
    //NSInteger *total;
    NSArray *allItems;
    NSArray *allItemss;
    NSMutableString *proIDs;
    NSMutableArray *collectIds;
    NSMutableArray *displayItems;
    __weak IBOutlet UIButton *back;
    __weak IBOutlet UIButton *home;
    IBOutlet UITableView *tableView;
    __weak IBOutlet UIButton *buttonClearOrder;
    __weak IBOutlet UIButton *buttonConfirmOrder;
    NSString *selectedTable;
    NSString *dateStr;
}
@property (strong, nonatomic) MLTableAlert *alert;

@property (nonatomic, retain) InfiniTabBar *tabBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic)NSString *selectedTable;

// UI
@property (nonatomic, retain) UILabel *dLabel;
@property (nonatomic, retain) UILabel *fLabel;

@property (nonatomic, weak) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *home;
@property (nonatomic, weak) IBOutlet UIButton *buttonClearOrder;
@property (weak, nonatomic) IBOutlet UIButton *buttonConfirmOrder;
@end
