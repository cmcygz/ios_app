//
//  Favourit.m
//  Food
//
//  Created by Malik Imran on 3/27/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import "Favourit.h"
#import "Home.h"
#import "HotDishCell.h"
#import "OrderPage.h"
#import "MyOrderCell.h"
#import "ConnectionUrls.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface Favourit ()

@end

@implementation Favourit
@synthesize  back;
@synthesize home;
@synthesize selectedSegment;
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
    [self setNeedsStatusBarAppearanceUpdate];
    collectIds = [[NSMutableArray alloc] init];
    collectTime = [[NSMutableArray alloc] init];
    if (selectedSegment.selectedSegmentIndex == 0) {
       
        NSLog(@"Yayyy : %d",selectedSegment.selectedSegmentIndex);
        allItems = [[NSArray alloc] init];
        displayItems = [[NSMutableArray alloc] initWithArray:allItems];
        [tableView reloadData];
    }
    else
        if (selectedSegment.selectedSegmentIndex == 1) {
                    NSLog(@"Cool : %d",selectedSegment.selectedSegmentIndex);
    [back addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [home addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
    allItems = [[NSArray alloc] initWithObjects:@"one",nil];
    displayItems = [[NSMutableArray alloc] initWithArray:allItems];
    [tableView reloadData];
        }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)keyboardShown:(NSNotification *)note{
    CGRect keyboardFrame;
    [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    CGRect tableViewFrame  = tableView.frame;
    tableViewFrame.size.height -= keyboardFrame.size.height;
    [tableView setFrame:tableViewFrame];
}

- (void)keyboardHidden:(NSNotification *)note{
    [tableView setFrame:self.view.bounds];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([selectedSegment selectedSegmentIndex] == 0) {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error=nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Favourite" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Total Cell's %d", [fetchedObjects count]);
    totalCell = [fetchedObjects count];
    }
    else if ([selectedSegment selectedSegmentIndex] == 1){
        NSError *error=nil;
        str=[NSString stringWithFormat:@"%@%@",Base_Url,Hot_Dish];
        url=[NSURL URLWithString:str];
        myNSData=[NSData dataWithContentsOfURL:url];
        
        allItemss = [NSJSONSerialization JSONObjectWithData:myNSData options:kNilOptions error:&error];
        int i = [allItemss count];
        totalCell = i;
    }
    return totalCell;
}
- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    HotDishCell *cell = (HotDishCell *)[atableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HotDishCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
#pragma   Fetch Dish Id from core data
    
    
    if ([selectedSegment selectedSegmentIndex] == 0) {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSError *error=nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Favourite" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        //NSLog(@"Fetch Object %@", [[fetchedObjects objectAtIndex:indexPath.row] valueForKey:@"dishid"]);
        NSMutableString *prodId = [[fetchedObjects objectAtIndex:indexPath.row] valueForKey:@"dishid"];
        str=[NSString stringWithFormat:@"%@%@",Base_Url,All_Dishes];
        str = [str stringByAppendingString:prodId];
        url=[NSURL URLWithString:str];
        myNSData=[NSData dataWithContentsOfURL:url];
        
        allItemss = [NSJSONSerialization JSONObjectWithData:myNSData options:kNilOptions error:&error];
        NSString *ids = [[allItemss objectAtIndex:0] objectForKey:@"id"];
        NSString *times = [[allItemss objectAtIndex:0] objectForKey:@"average_cooking_time_min"];
        [collectIds addObject:ids];
        [collectTime addObject:times];
        NSString *picName = [NSString stringWithFormat:@"%@%@",Base_Url,Dish_Name];
        picName = [picName stringByAppendingString:[[allItemss objectAtIndex:0] objectForKey:@"picture"]];
        [cell.ImageHotDish setImageWithURL:[NSURL URLWithString:picName]
                          placeholderImage:[UIImage imageNamed:nil]];
        
        cell.lableTitle.text = [[allItemss objectAtIndex:0] objectForKey:@"NAME"];
        cell.lablePrice.text = [[allItemss objectAtIndex:0] objectForKey:@"price"];
        
        [cell.buttonAdd addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
        if ([selectedSegment selectedSegmentIndex] == 1) {
            
            str=[NSString stringWithFormat:@"%@%@",Base_Url,Hot_Dish];
            url=[NSURL URLWithString:str];
            myNSData=[NSData dataWithContentsOfURL:url];
            NSError *error=nil;
            allItemss = [NSJSONSerialization JSONObjectWithData:myNSData options:kNilOptions error:&error];
            NSString *ids = [[allItemss objectAtIndex:indexPath.row] objectForKey:@"id"];
            NSString *times = [[allItemss objectAtIndex:indexPath.row] objectForKey:@"average_cooking_time_min"];
            [collectIds addObject:ids];
            [collectTime addObject:times];
            NSString *picName = [NSString stringWithFormat:@"%@%@",Base_Url,Dish_Name];
            picName = [picName stringByAppendingString:[[allItemss objectAtIndex:indexPath.row] objectForKey:@"picture"]];
            [cell.ImageHotDish setImageWithURL:[NSURL URLWithString:picName]
                              placeholderImage:[UIImage imageNamed:nil]];
            
            cell.lableTitle.text = [[allItemss objectAtIndex:indexPath.row] objectForKey:@"NAME"];
            cell.lablePrice.text = [[allItemss objectAtIndex:indexPath.row] objectForKey:@"price"];
            
            NSString *a = [[allItemss objectAtIndex:indexPath.row] objectForKey:@"price"];
            
            [cell.buttonAdd addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
        }
    
   
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;


}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderPage *go1 = [[OrderPage alloc] initWithNibName:@"OrderPage" bundle:nil];
    go1.temp = [[allItemss objectAtIndex:0] objectForKey:@"id"];
    [self presentViewController:go1 animated:YES completion:nil];
}

#pragma Delete Item From Favourite
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Do whatever data deletion you need to do...
        // Delete the row from the data source
        NSLog(@"Row Index is = %@", [collectIds objectAtIndex:indexPath.row]);
        NSString *alertString = [NSString stringWithFormat:@"Are You Sure To Remove Item # : %@ ",[collectIds objectAtIndex:indexPath.row]];
        proIDs =[collectIds objectAtIndex:indexPath.row];
        NSManagedObjectContext *context = [self managedObjectContext];
        NSError *error=nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Favourite" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        for (NSManagedObject *info in fetchedObjects) {
            NSLog(@"Here Dish ID = %@",[info valueForKey:@"dishid"]);
            NSLog(@"Here delete dish ID = %@", proIDs);
            NSString *id1 = [info valueForKey:@"dishid"];
            NSString *id2 = proIDs;
            if ([id1 isEqualToString:id2]) {
                [context deleteObject:info];
            }
        }
    }
    Favourit *go1 = [[Favourit alloc] initWithNibName:@"Favourit" bundle:nil];
    [self presentViewController:go1 animated:NO completion:nil];
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self->tableView];
    NSIndexPath *indexPath = [self->tableView indexPathForRowAtPoint:buttonPosition];
    NSLog(@"P ID = %@", [collectIds objectAtIndex:indexPath.row]);
    proIDs =[collectIds objectAtIndex:indexPath.row];
    time =[collectTime objectAtIndex:indexPath.row];
    if (indexPath != nil)
    {
        NSString *alertString = [NSString stringWithFormat:@"Home Many Plate Of : %@ ",[collectIds objectAtIndex:indexPath.row]];
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
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField *title1 = [alertView textFieldAtIndex:0];
    
    title1= [alertView textFieldAtIndex:0];
    NSString *title = title1.text;
    if (buttonIndex == 0){
        NSLog(@"Cancel");
    }else{
        NSLog(@"The quantity is %@",title);
        //s
        NSLog(@"Dish ID = %@", proIDs);
        NSManagedObjectContext *context = [self managedObjectContext];
        NSError *error=nil;
        // Create a new device
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"PendingOrder" inManagedObjectContext:context];
        [newDevice setValue:proIDs forKey:@"dishid"];
        [newDevice setValue:title forKey:@"quantity"];
        [newDevice setValue:time forKey:@"time"];
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)segmentControl:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl*) sender;
    if ([segmentedControl selectedSegmentIndex] == 0) {
        NSLog(@"Selected Segment = %d",[segmentedControl selectedSegmentIndex]);
        allItems = [[NSArray alloc] initWithObjects:@"one",@"two",@"three",@"four",@"five",@"six",@"seven",nil];
        displayItems = [[NSMutableArray alloc] initWithArray:allItems];
        [tableView reloadData];
         titleLable.text = @"My Favourite";
    }
   else
       if ([segmentedControl selectedSegmentIndex] == 1) {
       NSLog(@"Selected Segment = %d",[segmentedControl selectedSegmentIndex]);
    allItems = [[NSArray alloc] initWithObjects:@"one",nil];
    displayItems = [[NSMutableArray alloc] initWithArray:allItems];
           
           NSString *str=Hot_Dish;
           NSURL *url=[NSURL URLWithString:str];
           NSData *myNSData=[NSData dataWithContentsOfURL:url];
           [tableView reloadData];
           titleLable.text = @"Most Order";

       }
}
- (IBAction)buttonPressed:(UIButton *)sender
{
    Home *go1 = [[Home alloc] initWithNibName:@"Home" bundle:nil];
    [self presentViewController:go1 animated:YES completion:nil];
}

@end
