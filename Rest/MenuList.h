//
//  MenuList.h
//  Rest
//
//  Created by Malik Imran on 4/3/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MenuList : UIViewController<UITableViewDelegate,  UITableViewDataSource, UISearchBarDelegate> {
    
    __weak IBOutlet UIButton *back;
    __weak IBOutlet UIButton *home;
    IBOutlet UITableView *tableView;
    
    NSArray *allItems;
    NSMutableArray *displayItems;
}
@property (nonatomic, weak) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *home;

@end