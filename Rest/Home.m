//
//  Home.m
//  Food
//
//  Created by Malik Imran on 3/23/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import "Home.h"
#import "HomeMenuCell.h"
#import "MHNibTableViewCell.h"
#import "HotDishes.h"
#import "MyOrder.h"
#import "Favourit.h"
#import "MenuList.h"
#import "AppDelegate.h"
#import "MLTableAlert.h"
#import "jsonViewController.h"
#import "FeedBack.h"
@interface Home ()
@property (strong) NSMutableArray *UDID;
@end

@implementation Home
@synthesize time;
int hours, minutes, seconds;
int secondsLeft;
NSTimer *timer;
@synthesize device;

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
//- (void) loadView
//{
//    [super loadView];
//    self.view.frame = [UIScreen mainScreen].bounds;
//}
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

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [_buttonHotDish addTarget:self action:@selector(HotDish:) forControlEvents: UIControlEventTouchUpInside];
    [_buttonMenu addTarget:self action:@selector(Menu:) forControlEvents: UIControlEventTouchUpInside];
    [_buttonMyOrder addTarget:self action:@selector(MyOrder:) forControlEvents: UIControlEventTouchUpInside];
    [_buttonFavourite addTarget:self action:@selector(Favourite:) forControlEvents: UIControlEventTouchUpInside];
    [_buttonCallWaiter addTarget:self action:@selector(CallWaiter:) forControlEvents: UIControlEventTouchUpInside];
    [_buttonContactUs addTarget:self action:@selector(ContactUs:) forControlEvents: UIControlEventTouchUpInside];
    
    
#pragma Generate UDID
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error=nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"UDID" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"GOT ID: %@", [info valueForKey:@"id"]);
        appDelegate.passUdid = [info valueForKey:@"id"];
    }
    
    if ([fetchedObjects count] == nil) {
        NSString *uuid = [[NSUUID UUID] UUIDString];
        NSLog(@"Got It = %@",uuid);
        
        // Create a new device
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"UDID" inManagedObjectContext:context];
        [newDevice setValue:uuid forKey:@"id"];
        appDelegate.passUdid = uuid;
    }
    
    
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }

    
    
    secondsLeft = 300;
    //NSCalendar * calendar = [NSCalendar currentCalendar];
//    NSDateComponents * components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSSecondCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit
//                                                fromDate:[NSDate date]];
    //    NSString * stringDate = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d", components.year, components.month, components.day, components.hour, components.minute, components.second];
    //secondsLeft = secondsLeft - components.second;
    
    [self countdownTimer];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)updateCounter:(NSTimer *)theTimer {
    
    if(secondsLeft > 0 ){
        secondsLeft -- ;
        hours = secondsLeft / 3600;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft %3600) % 60;
        time.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }
    else{
//        NSCalendar * calendar = [NSCalendar currentCalendar];
//        NSDateComponents * components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSSecondCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit
//                                                    fromDate:[NSDate date]];
        
        
        secondsLeft = 300;
    }    // Do any additional setup after loading the view from its nib.
    
}
-(void)countdownTimer{
    
    secondsLeft = hours = minutes = seconds = 0;
    if([timer isValid])
    {
        //[timer release];
    }
    // NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    //[pool release];
}


-(void)HotDish:(id)sender{
    
    HotDishes *go1 = [[HotDishes alloc] initWithNibName:@"HotDishes" bundle:nil];
    [self presentViewController:go1 animated:YES completion:nil];
    
}
-(void)Menu:(id)sender{
    
    MenuList *go1 = [[MenuList alloc] initWithNibName:@"MenuList" bundle:nil];
    [self presentViewController:go1 animated:YES completion:nil];
}
-(void)MyOrder:(id)sender{
    
    MyOrder *go1 = [[MyOrder alloc] initWithNibName:@"MyOrder" bundle:nil];
    [self presentViewController:go1 animated:YES completion:nil];
}
-(void)Favourite:(id)sender{
    
    Favourit *go1 = [[Favourit alloc] initWithNibName:@"Favourit" bundle:nil];
    [self presentViewController:go1 animated:YES completion:nil];
}
-(void)CallWaiter:(id)sender{

        
#pragma Select Table Alert Box
        _alert = [MLTableAlert tableAlertWithTitle:@"Select Your Table" cancelButtonTitle:@"Cancel" numberOfRows:^NSInteger (NSInteger section)
                  {
                      
                      return 6;
                  }
                                          andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                  {
                      static NSString *CellIdentifier = @"CellIdentifier";
                      UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                      if (cell == nil)
                          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                      
                      cell.textLabel.text = [NSString stringWithFormat:@"Table # %d", indexPath.row];
                      
                      return cell;
                  }];
        
        [_alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
            
            NSLog(@"Index is = %d", selectedIndex.row);
            selectedTable = [NSString stringWithFormat:@"%d",selectedIndex.row];
#pragma Hit Url For New Order
            
            NSManagedObjectContext *context = [self managedObjectContext];
            NSError *error=nil;
            
            
            //e
            if (![selectedTable isEqualToString:NULL]) {
                                                       //s
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    NSString *ordrMain=[NSString stringWithFormat:@"http://localhost/food/call_waiter.php?cust_id=%@&table_no=%@&date=%@",appDelegate.passUdid,selectedTable,dateStr];
                NSString* urlTextEscaped = [ordrMain stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

                    NSURL *urls=[NSURL URLWithString:urlTextEscaped];
                    NSData *myNSData=[NSData dataWithContentsOfURL:urls];
                    
                }
                Home *go1 = [[Home alloc] initWithNibName:@"Home" bundle:nil];
                //[self presentModalViewController:go1 animated:YES];
                [self presentViewController:go1 animated:NO completion:nil];
                if (![context save:&error]) {
                    NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                
            }
            //end
            
        } andCompletionBlock:^{
            NSLog(@"Cancel Button Pressed\nNo Cells Selected");
        }];
        _alert.height = 260;
        [_alert show];
   
}

-(void)ContactUs:(id)sender{
    
    NSLog(@"Contact Us");
    FeedBack *go1 = [[FeedBack alloc] initWithNibName:@"FeedBack" bundle:nil];
    [self presentViewController:go1 animated:YES completion:nil];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end