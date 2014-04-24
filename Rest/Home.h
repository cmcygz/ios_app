//
//  Home.h
//  Food
//
//  Created by Malik Imran on 3/23/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLTableAlert;
@interface Home : UIViewController<UIApplicationDelegate> {
    
    
    __weak IBOutlet UILabel *labelTimer;
    NSString *selectedTable;
     NSString *dateStr;
}

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIButton *buttonHotDish;
@property (strong, nonatomic) IBOutlet UIButton *buttonMenu;
@property (strong, nonatomic) IBOutlet UIButton *buttonMyOrder;

@property (strong, nonatomic) IBOutlet UIButton *buttonFavourite;
@property (strong, nonatomic) IBOutlet UIButton *buttonCallWaiter;
@property (strong, nonatomic) IBOutlet UIButton *buttonContactUs;
@property (strong, nonatomic) MLTableAlert *alert;

@property (strong) NSManagedObject *device;
@end
