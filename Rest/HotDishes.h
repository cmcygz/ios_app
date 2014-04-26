//
//  HotDishes.h
//  Food
//
//  Created by Malik Imran on 3/24/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HotDishes : UIViewController<UITableViewDelegate,  UITableViewDataSource, UISearchBarDelegate, UIAlertViewDelegate> {
    
    __weak IBOutlet UIButton *back;
    __weak IBOutlet UIButton *home;
    IBOutlet UITableView *tableView;
    IBOutlet UISearchBar *searchBar;
    NSMutableString *proIDs;
    NSMutableString *time;
    NSMutableArray *allItems;
    NSMutableArray *displayItems;
}
@property (nonatomic, weak) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *home;
@end
