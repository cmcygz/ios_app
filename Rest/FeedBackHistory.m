//
//  FeedBackHistory.m
//  Rest
//
//  Created by Malik Imran on 4/22/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import "FeedBackHistory.h"
#import "HistoryCell.h"
#import "CSNotificationView.h"
#import "FeedBack.h"
#import "Home.h"
@interface FeedBackHistory ()

@end

@implementation FeedBackHistory
@synthesize starRatingView;
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
    allItems = [[NSArray alloc] init];
    NSString *str=@"http://localhost/food/read_feedback.php";
    NSURL *url=[NSURL URLWithString:str];
    NSData *myNSData=[NSData dataWithContentsOfURL:url];
    NSError *error=nil;
    allItems = [NSJSONSerialization JSONObjectWithData:myNSData options:kNilOptions error:&error];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)tabBar:(UITabBar *)theTabBar didSelectItem:(UITabBarItem *)item {
    NSUInteger indexOfTab = [[theTabBar items] indexOfObject:item];
    NSLog(@"Tab index = %u", indexOfTab);
    if (indexOfTab == 0) {
    FeedBack *go1 = [[FeedBack alloc] initWithNibName:@"FeedBack" bundle:nil];
    [self presentViewController:go1 animated:NO completion:nil];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [allItems count];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}
- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"Cell";
    
    HistoryCell *cell = (HistoryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
        cell.lableDate.text = [[allItems objectAtIndex:indexPath.row] objectForKey:@"created_on"];
        cell.lableRemarks.text = [[allItems objectAtIndex:indexPath.row] objectForKey:@"remarks"];
        starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0, 5, 150, 30)
                                                 numberOfStar:5];
        NSString *newRating = [[allItems objectAtIndex:indexPath.row] objectForKey:@"rating"];
        float fCost = [newRating floatValue];
        fCost = fCost / 100;
        [self.starRatingView setScore:fCost withAnimation:YES];
        [cell.starView addSubview:starRatingView];
        return cell;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonPressed:(UIButton *)sender
{
    Home *go1 = [[Home alloc] initWithNibName:@"Home" bundle:nil];
    [self presentViewController:go1 animated:YES completion:nil];
}
@end
