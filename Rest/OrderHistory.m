//
//  OrderHistory.m
//  Rest
//
//  Created by Malik Imran on 4/24/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import "OrderHistory.h"
#import "RunningOrder.h"
#import "MyOrder.h"
#import "Home.h"
@interface OrderHistory ()

@end

@implementation OrderHistory
@synthesize tabBar;
@synthesize back;
@synthesize home;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    [back addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [home addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

    UITabBarItem *favorites = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
    favorites = [[UITabBarItem alloc] initWithTitle:@"Order" image:nil tag:0];
    [favorites setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaLTStd-Roman" size:10.0f], NSFontAttributeName,  [UIColor redColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    [favorites setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaLTStd-Roman" size:10.0f], NSFontAttributeName,  [UIColor blueColor], NSForegroundColorAttributeName,nil] forState:UIControlStateHighlighted];
    [favorites setFinishedSelectedImage:[UIImage imageNamed:@"uorder.png"]withFinishedUnselectedImage:[UIImage imageNamed:@"sorder.png"]];
    //[favorites setImage:[[UIImage imageNamed:@"sorder.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    UITabBarItem *topRated = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:1];
    topRated = [[UITabBarItem alloc] initWithTitle:@"Running Order" image:nil tag:1];
    [topRated setFinishedSelectedImage:[UIImage imageNamed:@"uclock.png"]withFinishedUnselectedImage:[UIImage imageNamed:@"sclock.png"]];
	UITabBarItem *featured = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:2];
    featured = [[UITabBarItem alloc] initWithTitle:@"History" image:nil tag:2];
    [featured setFinishedSelectedImage:[UIImage imageNamed:@"shistory.png"]withFinishedUnselectedImage:[UIImage imageNamed:@"uhistory.png"]];
    
    
	self.tabBar = [[InfiniTabBar alloc] initWithItems:[NSArray arrayWithObjects:favorites,
													   topRated,
													   featured,
                                                       nil]];
	
    
	// Don't show scroll indicator
	self.tabBar.showsHorizontalScrollIndicator = NO;
	self.tabBar.infiniTabBarDelegate = self;
	self.tabBar.bounces = NO;
    //self.tableView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.tabBar];
}

- (IBAction)buttonPressed:(UIButton *)sender
{
    Home *go1 = [[Home alloc] initWithNibName:@"Home" bundle:nil];
    [self presentViewController:go1 animated:YES completion:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)infiniTabBar:(InfiniTabBar *)tabBar didSelectItemWithTag:(int)tag {
    if (tag == 0) {
        MyOrder *go1 = [[MyOrder alloc] initWithNibName:@"MyOrder" bundle:nil];
        [self presentViewController:go1 animated:NO completion:nil];
    }
    if (tag == 1) {
        RunningOrder *go1 = [[RunningOrder alloc] initWithNibName:@"RunningOrder" bundle:nil];
        [self presentViewController:go1 animated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
