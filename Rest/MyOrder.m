//
//  MyOrder.m
//  Food
//
//  Created by Malik Imran on 3/26/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import "MyOrder.h"
#import "Home.h"
#import "MyOrderCell.h"
#import "MLTableAlert.h"
#import "jsonViewController.h"
#import "AppDelegate.h"
#import "RunningOrder.h"
#import "OrderHistory.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
@implementation MyOrder

@synthesize tabBar;
@synthesize selectedTable;
// UI
@synthesize dLabel;
@synthesize fLabel;
@synthesize back;
@synthesize home;
@synthesize buttonClearOrder;
@synthesize buttonConfirmOrder;
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
int total = 0;
int count = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    total = 0;
    collectIds = [[NSMutableArray alloc] init];
    [self setNeedsStatusBarAppearanceUpdate];
    
#pragma get_current_date_and_time
    
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
    
    
    [back addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [home addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonClearOrder addTarget:self action:@selector(clearOrder:) forControlEvents:UIControlEventTouchUpInside];
    [buttonConfirmOrder addTarget:self action:@selector(confirmOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    allItems = [[NSArray alloc] init];
    displayItems = [[NSMutableArray alloc] init];

    // Items
	UITabBarItem *favorites = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
    favorites = [[UITabBarItem alloc] initWithTitle:@"Order" image:nil tag:0];
    [favorites setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaLTStd-Roman" size:10.0f], NSFontAttributeName,  [UIColor redColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    [favorites setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaLTStd-Roman" size:10.0f], NSFontAttributeName,  [UIColor blueColor], NSForegroundColorAttributeName,nil] forState:UIControlStateHighlighted];
    [favorites setFinishedSelectedImage:[UIImage imageNamed:@"sorder.png"]withFinishedUnselectedImage:[UIImage imageNamed:@"uorder.png"]];
    //[favorites setImage:[[UIImage imageNamed:@"sorder.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    UITabBarItem *topRated = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:1];
    topRated = [[UITabBarItem alloc] initWithTitle:@"Running Order" image:nil tag:1];
    [topRated setFinishedSelectedImage:[UIImage imageNamed:@"uclock.png"]withFinishedUnselectedImage:[UIImage imageNamed:@"sclock.png"]];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UIView *)tableView:(UITableView *)atableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, atableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, atableView.frame.size.width, 12)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    label.textAlignment = NSTextAlignmentCenter;
    NSString *string = @"Total Order : $ ";
    NSString * totalVal = [NSString stringWithFormat:@"%d",total];
    string = [string stringByAppendingString:totalVal];
    [label setText:string];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:0.502 green:0.702 blue:0.114 alpha:1]];
    return view;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error=nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"PendingOrder" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Total Cell's %d", [fetchedObjects count]);
    return [fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    MyOrderCell *cell = (MyOrderCell *)[atableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyOrderCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //Fetch Dish Id from core data
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error=nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"PendingOrder" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Fetch Object %@", [[fetchedObjects objectAtIndex:indexPath.row] valueForKey:@"dishid"]);
    NSMutableString *prodId = [[fetchedObjects objectAtIndex:indexPath.row] valueForKey:@"dishid"];
    
    NSString *str=@"http://localhost/food/all_dishes.php?id=";
        str = [str stringByAppendingString:prodId];
        NSURL *url=[NSURL URLWithString:str];
        NSData *myNSData=[NSData dataWithContentsOfURL:url];
   
        allItemss = [NSJSONSerialization JSONObjectWithData:myNSData options:kNilOptions error:&error];
   
            NSString *picName = @"file:///Users/malikimran/Desktop/RestAutomationAdmin/WebContent/uploads/dish/";
            picName = [picName stringByAppendingString:[[allItemss objectAtIndex:0] objectForKey:@"picture"]];
    cell.ImageOrderMenu.layer.cornerRadius = 0.0;
    cell.ImageOrderMenu.layer.masksToBounds = YES;
    [cell.ImageOrderMenu setImageWithURL:[NSURL URLWithString:picName]
                                placeholderImage:[UIImage imageNamed:nil]];
            
            cell.LableOrderMenu.text = [[allItemss objectAtIndex:0] objectForKey:@"NAME"];
            cell.lablePriceOrderMenu.text = [[allItemss objectAtIndex:0] objectForKey:@"price"];
    //quantity
    //s
    
    
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"Here Dish ID = %@",[info valueForKey:@"dishid"]);
        NSLog(@"Here delete dish ID = %@", proIDs);
        NSString *id1 = [info valueForKey:@"dishid"];
        NSString *id2 = prodId;
        if ([id1 isEqualToString:id2]) {
            NSString *sub = [info valueForKey:@"quantity"];
            cell.lableQuantity.text = sub;
            NSInteger q = [sub integerValue];
            NSString *a = [[allItemss objectAtIndex:0] objectForKey:@"price"];
            NSInteger b = [a integerValue];
            b = b * q;
            total = total + b;
        }
        
        
    }
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }

    //e
    
    NSString *v = [[allItemss objectAtIndex:0] objectForKey:@"id"];
    [collectIds addObject:v];
    count++;
    [cell.buttonSubtractOrder addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Do whatever data deletion you need to do...
        // Delete the row from the data source
       NSLog(@"Row Index is = %@", [collectIds objectAtIndex:indexPath.row]);
        NSString *alertString = [NSString stringWithFormat:@"Are You Sure To Remove Item # : %@ ",[collectIds objectAtIndex:indexPath.row]];
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Remove ITEM !"
                                                       message:alertString
                                                      delegate:nil
                                             cancelButtonTitle:@"No"
                                             otherButtonTitles:@"Yes",
                             nil];
        alert.delegate = self;
        [alert show];
        proIDs =[collectIds objectAtIndex:indexPath.row];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 
    if (buttonIndex == 1) {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error=nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"PendingOrder" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"Here Dish ID = %@",[info valueForKey:@"dishid"]);
        NSLog(@"Here delete dish ID = %@", proIDs);
        NSString *id1 = [info valueForKey:@"dishid"];
        NSString *id2 = proIDs;
        if ([id1 isEqualToString:id2]) {
            
            
            NSMutableString *sub = [[allItemss objectAtIndex:0] objectForKey:@"price"];
            NSInteger b = [sub integerValue];
            //total = total - b;
            [context deleteObject:info];
        }
        
        
    }
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
    MyOrder *go1 = [[MyOrder alloc] initWithNibName:@"MyOrder" bundle:nil];
    [self presentViewController:go1 animated:NO completion:nil];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyOrder *go1 = [[MyOrder alloc] initWithNibName:@"MyOrder" bundle:nil];
    //[self presentViewController:go1 animated:YES completion:nil];
}
- (IBAction)buttonPressed:(UIButton *)sender
{
    NSLog(@"Sender = %@", sender);
    Home *go1 = [[Home alloc] initWithNibName:@"Home" bundle:nil];
    [self presentViewController:go1 animated:YES completion:nil];
}

- (IBAction)clearOrder:(UIButton *)sender
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error=nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"PendingOrder" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *info in fetchedObjects) {
        [context deleteObject:info];
        
    }
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    MyOrder *go1 = [[MyOrder alloc] initWithNibName:@"MyOrder" bundle:nil];
    [self presentViewController:go1 animated:NO completion:nil];
    total = 0;

}

#pragma mark Confirm Order
- (IBAction)confirmOrder:(UIButton *)sender
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error=nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"PendingOrder" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];


    if ([fetchedObjects count] > 0) {
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
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSLog(@"Got udid from appdelegate = %@",appDelegate.passUdid);
        NSString *new_order = [NSString stringWithFormat: @"http://localhost/food/submit_new_order.php?id=NULL&customer_id=%@&table_id=%@&order_datetime=%@&customer_instruction=Normal&estimated_time_min=30-45&actual_time=40&created_on=%@&updated_on=NULL&STATUS=new", appDelegate.passUdid,selectedTable,dateStr,dateStr];
        NSString* urlTextEscaped = [new_order stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url=[NSURL URLWithString:urlTextEscaped];
        NSData *myNSData=[NSData dataWithContentsOfURL:url];
        
        NSManagedObjectContext *context = [self managedObjectContext];
        NSError *error=nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"PendingOrder" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        if (![selectedTable isEqualToString:NULL]) {
            
            for (NSManagedObject *info in fetchedObjects) {
                NSMutableString *pDishID = [info valueForKey:@"dishid"];
                NSMutableString *pDishQuantity = [info valueForKey:@"quantity"];
                NSMutableString *time = [info valueForKey:@"time"];
                NSManagedObject *newDevices = [NSEntityDescription insertNewObjectForEntityForName:@"RunningOrder" inManagedObjectContext:context];
                [newDevices setValue:pDishID forKey:@"dishid"];
                [newDevices setValue:pDishQuantity forKey:@"quantity"];
                [newDevices setValue:time forKey:@"time"];
                
                NSLog(@"Getting ID From pending Order = %@",[info valueForKey:@"dishid"]);
#pragma Get Order ID from Order_Main
                
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                NSString *ordrMain=@"http://localhost/food/get_order_id.php?id=";
                ordrMain = [ordrMain stringByAppendingString:appDelegate.passUdid];
                NSURL *urls=[NSURL URLWithString:ordrMain];
                NSData *myNSData=[NSData dataWithContentsOfURL:urls];
                
                allItemss = [NSJSONSerialization JSONObjectWithData:myNSData options:kNilOptions error:&error];
                NSDictionary *results = [NSJSONSerialization JSONObjectWithData:myNSData options:NSJSONReadingMutableContainers error:nil];
                NSString *get_order_id = [[allItemss objectAtIndex:0] objectForKey:@"id"];
                NSString *new_order_detail = [NSString stringWithFormat: @"http://localhost/food/order_detail.php?order_id=%@&dish_id=%@&quantity=%@&created_on=%@&updated_on=%@", get_order_id,pDishID,pDishQuantity,dateStr,dateStr];
                NSString* urlTextEscaped = [new_order_detail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url=[NSURL URLWithString:urlTextEscaped];
                NSData *myNSDatas=[NSData dataWithContentsOfURL:url];
                
                //e
                [context deleteObject:info];
                
            }
            MyOrder *go1 = [[MyOrder alloc] initWithNibName:@"MyOrder" bundle:nil];
            [self presentViewController:go1 animated:NO completion:nil];
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
        }
    } andCompletionBlock:^{
		NSLog(@"Cancel Button Pressed\nNo Cells Selected");
	}];
    _alert.height = 260;
    [_alert show];
    total = 0;
    }
    else if ([fetchedObjects count] == 0){
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Empty !"
                                                       message:@"Empty Order Cannot Processed"
                                                      delegate:self
                                             cancelButtonTitle:@"ok"
                                             otherButtonTitles:nil];
        alert.delegate = self;
        [alert show];
    }
    
}

- (void)scrollToPreviousTabBar {
	[self.tabBar scrollToTabBarWithTag:self.tabBar.currentTabBarTag - 1 animated:YES];
}

- (void)scrollToNextTabBar {
	[self.tabBar scrollToTabBarWithTag:self.tabBar.currentTabBarTag + 1 animated:YES];
}

- (void)infiniTabBar:(InfiniTabBar *)tabBar didScrollToTabBarWithTag:(int)tag {
	self.dLabel.text = [NSString stringWithFormat:@"%d", tag + 1];
}

- (void)infiniTabBar:(InfiniTabBar *)tabBar didSelectItemWithTag:(int)tag {
	self.fLabel.text = [NSString stringWithFormat:@"Its Working %d", tag];
    NSLog(@"Its working here %d", tag);
    if (tag == 2) {
        OrderHistory *go1 = [[OrderHistory alloc] initWithNibName:@"OrderHistory" bundle:nil];
        //[self presentModalViewController:go1 animated:YES];
        [self presentViewController:go1 animated:NO completion:nil];
    }
    if (tag == 1) {
        RunningOrder *go1 = [[RunningOrder alloc] initWithNibName:@"RunningOrder" bundle:nil];
        //[self presentModalViewController:go1 animated:YES];
        [self presentViewController:go1 animated:NO completion:nil];
    }
}


- (void)dealloc {
    
}

@end