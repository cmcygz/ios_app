//
//  FeedBack.m
//  Rest
//
//  Created by Malik Imran on 4/22/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import "FeedBack.h"
#import "AppDelegate.h"
#import "CSNotificationView.h"
#import "FeedBackHistory.h"
#import "Home.h"
@interface FeedBack ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic, strong) CSNotificationView* permanentNotification;
@end

@implementation FeedBack
@synthesize home;
@synthesize back;
@synthesize tabBar;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [back addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [home addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter1 dateFromString:dateStr];
    NSLog(@"date : %@",date);
    
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:date];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:date];
    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    
    NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:date];
    
    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
    [dateFormatters setDateFormat:@"dd-MMM-yyyy hh:mm"];
    [dateFormatters setDateStyle:NSDateFormatterShortStyle];
    [dateFormatters setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatters setDoesRelativeDateFormatting:YES];
    [dateFormatters setTimeZone:[NSTimeZone systemTimeZone]];
    dateStr = [dateFormatters stringFromDate: destinationDate];
    NSLog(@"DateString : %@", dateStr);
    [tabBar setTintColor:[UIColor blueColor]];
    tabBar.barTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
    
    _starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(30, 75, 260, 50)
                                                 numberOfStar:5];
    _starRatingView.delegate = self;
    [self.view addSubview:_starRatingView];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)tabBar:(UITabBar *)theTabBar didSelectItem:(UITabBarItem *)item {
    NSUInteger indexOfTab = [[theTabBar items] indexOfObject:item];
    NSLog(@"Tab index = %u", indexOfTab);
    if (indexOfTab == 1) {
    FeedBackHistory *go1 = [[FeedBackHistory alloc] initWithNibName:@"FeedBackHistory" bundle:nil];
    [self presentViewController:go1 animated:NO completion:nil];
    }
}
- (IBAction)BackgroundTap:(id)sender
{
    [_comment_area resignFirstResponder];
}
-(void)starRatingView:(TQStarRatingView *)view score:(float)score
{
    self.scoreLabel.text = [NSString stringWithFormat:@"%0.2f",score * 10 ];
}

- (IBAction)buttonPostFeedBack:(id)sender {
    NSString *cmnt = _comment_area.text;
    NSString *newRating = self.scoreLabel.text;
    float fCost = [newRating floatValue];
    fCost = fCost / 10;
    [self.starRatingView setScore:fCost withAnimation:YES];
    [_comment_area resignFirstResponder];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *ordrMain=[NSString stringWithFormat:@"http://localhost/food/feedback.php?cust_id=%@&remark=%@&rating=%@&date=%@",appDelegate.passUdid,_comment_area.text,cmnt,dateStr];
    NSString* urlTextEscaped = [ordrMain stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urls=[NSURL URLWithString:urlTextEscaped];
    NSData *myNSData=[NSData dataWithContentsOfURL:urls];
    self.scoreLabel.text = newRating;
    _comment_area.text = nil;
    [CSNotificationView showInViewController:self
                                   tintColor:[UIColor greenColor]
                                       image:[UIImage imageNamed:@"sucess"]
                                     message:@"Thanks For Providing FeedBack."
                                    duration:3.8f];
    
    [self.permanentNotification setShowingActivity:YES];

}
- (void)cancel
{
    self.navigationItem.rightBarButtonItem = nil;
    [self.permanentNotification dismissWithStyle:CSNotificationViewStyleError
                                         message:@"Cancelled"
                                        duration:kCSNotificationViewDefaultShowDuration animated:YES];
    self.permanentNotification = nil;
    
}

- (void)success
{
    self.navigationItem.rightBarButtonItem = nil;
    [self.permanentNotification dismissWithStyle:CSNotificationViewStyleSuccess
                                         message:@"Sucess!"
                                        duration:kCSNotificationViewDefaultShowDuration animated:YES];
    self.permanentNotification = nil;
}

- (IBAction)buttonPressed:(UIButton *)sender
{
    Home *go1 = [[Home alloc] initWithNibName:@"Home" bundle:nil];
    [self presentViewController:go1 animated:YES completion:nil];
}
@end
