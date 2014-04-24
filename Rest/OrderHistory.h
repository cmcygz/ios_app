//
//  OrderHistory.h
//  Rest
//
//  Created by Malik Imran on 4/24/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfiniTabBar.h"
@interface OrderHistory : UIViewController<InfiniTabBarDelegate>{
    InfiniTabBar *tabBar;
    __weak IBOutlet UIButton *back;
    __weak IBOutlet UIButton *home;
}
@property (nonatomic, retain) InfiniTabBar *tabBar;
@property (nonatomic, weak) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *home;
@end
