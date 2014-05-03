//
//  OrderPage.m
//  Food
//
//  Created by Malik Imran on 3/24/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import "OrderPage.h"
#import "Home.h"
#import "CSNotificationView.h"
#import "ConnectionUrls.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface OrderPage ()
@property (strong) NSMutableArray *UDID;
@property (nonatomic, strong) CSNotificationView* permanentNotification;
@end

@implementation OrderPage
@synthesize back;
@synthesize home;
@synthesize device;

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

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
    //NSLog(@"Temp value ID = %@",_temp);
    NSString *pid = [NSString stringWithFormat:@"%@", _temp];
    [self setNeedsStatusBarAppearanceUpdate];
    allItems = [[NSArray alloc] init];
    
    [back addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [home addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    NSString *picName = [NSString stringWithFormat:@"%@%@",Base_Url,Dish_Name];
    NSString *str=[NSString stringWithFormat:@"%@%@",Base_Url,Single_Dish];
    str = [str stringByAppendingString:pid];
    NSURL *url=[NSURL URLWithString:str];
    NSData *myNSData=[NSData dataWithContentsOfURL:url];
    NSError *error=nil;
    allItems = [NSJSONSerialization JSONObjectWithData:myNSData options:kNilOptions error:&error];
    results = [NSJSONSerialization JSONObjectWithData:myNSData options:NSJSONReadingMutableContainers error:nil];
    picName = [picName stringByAppendingString:[results objectForKey:@"picture"]];
    _lablePTitle.text = [results objectForKey:@"NAME"];
    _lablePName.text = [results objectForKey:@"NAME"];
    _lablePPrice.text = [results objectForKey:@"price"];
    _lableDiscount.text = [results objectForKey:@"discount"];
    _lableCalories.text = [results objectForKey:@"calories_per_100_grams"];
    _lableCookingTime.text = [results objectForKey:@"average_cooking_time_min"];
    _lableDescription.text = [results objectForKey:@"description"];
    [_imageDish setImageWithURL:[NSURL URLWithString:picName]placeholderImage:[UIImage imageNamed:nil]]; //sdwebimage library
    
    //asynchronously download image
//    NSString *picName = @"http://krazyidea.com/RestAutomationAdmin/WebContent/uploads/dish/";
//    picName = [picName stringByAppendingString:[results objectForKey:@"picture"]];
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:picName]];
//    _imageDish.image = [UIImage imageWithData:imageData];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
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


#pragma Add to order Button
- (IBAction)buttonAddToOrder:(id)sender {
        NSString *alertString = [NSString stringWithFormat:@"Home Many Plate Of : %@ ",[results objectForKey:@"NAME"]];
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"QUANTITY"
                                                       message:alertString
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"ok",
                             nil];
        alert.delegate = self;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField *title1 = [alertView textFieldAtIndex:0];
    
    title1= [alertView textFieldAtIndex:0];
    NSString *title = title1.text;
    if (buttonIndex == 0){
        NSLog(@"Cancel");
    }else{

        NSManagedObjectContext *context = [self managedObjectContext];
        NSError *error=nil;
        NSManagedObject *newDevices = [NSEntityDescription insertNewObjectForEntityForName:@"PendingOrder" inManagedObjectContext:context];
        [newDevices setValue:[results objectForKey:@"id"] forKey:@"dishid"];
        [newDevices setValue:title forKey:@"quantity"];
        [newDevices setValue:[results objectForKey:@"average_cooking_time_min"] forKey:@"time"];
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        //e
    }
}

- (IBAction)buttonAddToFavourite:(id)sender {
    int count = 0;
   
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error=nil;
    NSManagedObject *addToFav = [NSEntityDescription insertNewObjectForEntityForName:@"Favourite" inManagedObjectContext:context];
    NSString *dish = [results objectForKey:@"id"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Favourite" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *info in fetchedObjects) {
        NSString *id1 = [info valueForKey:@"dishid"];
        
        if ([id1 isEqualToString:dish]) {
            count = count +1;
        }
    }
    if (count == 0) {
        [addToFav setValue:[results objectForKey:@"id"] forKey:@"dishid"];
        [CSNotificationView showInViewController:self
                                       tintColor:[UIColor greenColor]
                                           image:[UIImage imageNamed:@"sucess"]
                                         message:@"Dish Added Sucessfully."
                                        duration:3.8f];
        
        [self.permanentNotification setShowingActivity:YES];

    }
    else if (count > 0){
        [CSNotificationView showInViewController:self
                                       tintColor:[UIColor redColor]
                                           image:[UIImage imageNamed:@"sucess"]
                                         message:@"Dish Already Added."
                                        duration:3.8f];
        
        [self.permanentNotification setShowingActivity:YES];

           }
    
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}




@end
