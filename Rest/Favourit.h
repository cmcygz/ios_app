//
//  Favourit.h
//  Food
//
//  Created by Malik Imran on 3/27/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Favourit : UIViewController<UITableViewDelegate,  UITableViewDataSource>{
    __weak IBOutlet UIButton *back;
    __weak IBOutlet UIButton *home;
    IBOutlet UITableView *tableView;
    IBOutlet UILabel *titleLable;
    NSArray *allItems;
    NSArray *allItemss;
    NSMutableArray *displayItems;
    NSMutableArray *displayItemss;
    NSMutableString *proIDs;
    NSMutableString *time;
    NSMutableArray *collectIds;
    NSMutableArray *collectTime;
    NSString *str;
    NSURL *url;
    NSData *myNSData;
    NSInteger *totalCell;
}
- (IBAction)segmentControl:(id)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *selectedSegment;
@property (nonatomic, weak) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *home;

@end
