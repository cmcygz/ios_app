//
//  RunningOrder.m
//  Rest
//
//  Created by Malik Imran on 4/23/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import "RunningOrder.h"
#import "Home.h"
#import "RunningOrderCell.h"
#import "AppDelegate.h"
#import "MyOrder.h"
#import "OrderHistory.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface RunningOrder ()

@end

@implementation RunningOrder
@synthesize tabBar;
@synthesize back;
@synthesize home;
int i = 0;
NSInteger *ind = 0;
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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *str=[NSString stringWithFormat:@"http://localhost/food/section_header.php?cust_id=%@",appDelegate.passUdid];
    NSURL *url=[NSURL URLWithString:str];
    NSData *myNSData=[NSData dataWithContentsOfURL:url];
    NSError *error=nil;
    allItems = [NSJSONSerialization JSONObjectWithData:myNSData options:kNilOptions error:&error];
    //
    NSString *strs=[NSString stringWithFormat:@"http://localhost/food/number_of_records.php?cust_id=%@",appDelegate.passUdid];
    NSURL *urls=[NSURL URLWithString:strs];
    NSData *myNSDatas=[NSData dataWithContentsOfURL:urls];
    total_rows = [NSJSONSerialization JSONObjectWithData:myNSDatas options:kNilOptions error:&error];
    
    //
    NSString *strss=[NSString stringWithFormat:@"http://localhost/food/read_order_history.php?cust_id=%@",appDelegate.passUdid];
    NSURL *urlss=[NSURL URLWithString:strss];
    NSData *myNSDatass=[NSData dataWithContentsOfURL:urlss];
    order_history = [NSJSONSerialization JSONObjectWithData:myNSDatass options:kNilOptions error:&error];
    
    UITabBarItem *favorites = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
    favorites = [[UITabBarItem alloc] initWithTitle:@"Order" image:nil tag:0];
    [favorites setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaLTStd-Roman" size:10.0f], NSFontAttributeName,  [UIColor redColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    [favorites setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaLTStd-Roman" size:10.0f], NSFontAttributeName,  [UIColor blueColor], NSForegroundColorAttributeName,nil] forState:UIControlStateHighlighted];
    [favorites setFinishedSelectedImage:[UIImage imageNamed:@"uorder.png"]withFinishedUnselectedImage:[UIImage imageNamed:@"sorder.png"]];
    //[favorites setImage:[[UIImage imageNamed:@"sorder.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    UITabBarItem *topRated = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:1];
    topRated = [[UITabBarItem alloc] initWithTitle:@"Running Order" image:nil tag:1];
    [topRated setFinishedSelectedImage:[UIImage imageNamed:@"sclock.png"]withFinishedUnselectedImage:[UIImage imageNamed:@"uclock.png"]];
	UITabBarItem *featured = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:2];
    featured = [[UITabBarItem alloc] initWithTitle:@"History" image:nil tag:2];
    [featured setFinishedSelectedImage:[UIImage imageNamed:@"uhistory.png"]withFinishedUnselectedImage:[UIImage imageNamed:@"shistory.png"]];
    
    
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
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [allItems count];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    
    UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 32)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 22)];
    [label setFont:[UIFont boldSystemFontOfSize:22]];
    //NSString *ordrid = @"Order ID : ";
    NSString *string =[[allItems objectAtIndex:section] valueForKey:@"id"];
    //ordrid = [ordrid stringByAppendingString:string];
    /* Section header is in 0th index... */
    [label setText:string];
    [label setTextColor:[UIColor whiteColor]];
    [views addSubview:label];
    [views setBackgroundColor:[UIColor colorWithRed:0.549 green:0.753 blue:0.188 alpha:1]];
    return label.text;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    for (int i = 0; i <= allItems.count; i++) {
        if (section==i)
        {
            NSString *a = [[total_rows objectAtIndex:i] valueForKey:@"Detail_Id"];
            NSInteger b = [a integerValue];
            return b;
        }
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    RunningOrderCell *cell = (RunningOrderCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RunningOrderCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSLog(@"Index = %d", indexPath.section);
    NSLog(@"Next Index = %@",[[allItems objectAtIndex:indexPath.section]valueForKey:@"id"]);
    NSString *a = [[allItems objectAtIndex:indexPath.section]valueForKey:@"id"];
//    NSInteger b = [a integerValue];
//    NSString *sectionTitle =[self tableView:tableView titleForHeaderInSection:sectionTitle];
    //if ([sectionTitle isEqualToString:a]) {
    NSError *error=nil;
    NSString *get_ordr_id=[NSString stringWithFormat:@"http://localhost/food/order_id.php?order_id=%@",a];
    NSURL *get_data=[NSURL URLWithString:get_ordr_id];
    NSData *fetch_data=[NSData dataWithContentsOfURL:get_data];
    order_id = [NSJSONSerialization JSONObjectWithData:fetch_data options:kNilOptions error:&error];
    
    cell.lableTitle.text = [[order_id objectAtIndex:indexPath.row] objectForKey:@"dish_id"];
    cell.lablePrice.text = [[order_id objectAtIndex:indexPath.row] objectForKey:@"quantity"];
    //dish_img
    NSString *get_ordr_ids=[NSString stringWithFormat:@"http://localhost/food/get_dish_img.php?dish_id=%@",[[order_id objectAtIndex:indexPath.row] objectForKey:@"dish_id"]];
    NSURL *get_datas=[NSURL URLWithString:get_ordr_ids];
    NSData *fetch_cmpltData=[NSData dataWithContentsOfURL:get_datas];
    dish_img = [NSJSONSerialization JSONObjectWithData:fetch_cmpltData options:kNilOptions error:&error];
    
    NSString *img = [[dish_img objectAtIndex:0] objectForKey:@"picture"];
    
    NSString *picName = [NSString stringWithFormat:@"file:///Users/malikimran/Desktop/RestAutomationAdmin/WebContent/uploads/dish/%@",img ];
    //picName = [picName stringByAppendingString:[[dish_img objectAtIndex:0] objectForKey:@"picture"]];
    [cell.ImageRunningOrder setImageWithURL:[NSURL URLWithString:picName]
                      placeholderImage:[UIImage imageNamed:nil]];

    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}
- (void)infiniTabBar:(InfiniTabBar *)tabBar didSelectItemWithTag:(int)tag {
    if (tag == 2) {
        OrderHistory *go1 = [[OrderHistory alloc] initWithNibName:@"OrderHistory" bundle:nil];
        [self presentViewController:go1 animated:NO completion:nil];
    }
    if (tag == 0) {
        MyOrder *go1 = [[MyOrder alloc] initWithNibName:@"MyOrder" bundle:nil];
        [self presentViewController:go1 animated:NO completion:nil];
    }
}

#pragma Go Back Home
- (IBAction)buttonPressed:(UIButton *)sender
{
    Home *go1 = [[Home alloc] initWithNibName:@"Home" bundle:nil];
    [self presentViewController:go1 animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
