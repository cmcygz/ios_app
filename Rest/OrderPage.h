//
//  OrderPage.h
//  Food
//
//  Created by Malik Imran on 3/24/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderPage : UIViewController{
    __weak IBOutlet UIButton *back;
    __weak IBOutlet UIButton *home;
     NSArray *allItems;
    NSDictionary *results;
}

@property (nonatomic, weak) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *home;
@property (assign) int temp;
@property (strong, nonatomic) IBOutlet UIImageView *imageDish;

@property (strong, nonatomic) IBOutlet UILabel *lablePTitle;
@property (strong, nonatomic) IBOutlet UILabel *lablePName;
@property (strong, nonatomic) IBOutlet UILabel *lablePPrice;

@property (strong, nonatomic) IBOutlet UILabel *lableDiscount;
@property (strong, nonatomic) IBOutlet UILabel *lableCalories;
@property (strong, nonatomic) IBOutlet UILabel *lableCookingTime;
@property (strong, nonatomic) IBOutlet UILabel *lableIngredient;
@property (strong, nonatomic) IBOutlet UILabel *lableDescription;
- (IBAction)buttonAddToOrder:(id)sender;
- (IBAction)buttonAddToFavourite:(id)sender;

@property (strong) NSManagedObject *device;

@end
