//
//  MenuList.m
//  Rest
//
//  Created by Malik Imran on 4/3/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import "MenuList.h"

#import "HotDishes.h"

#import "Home.h"
#import "OrderPage.h"
#import "MyOrder.h"
#import "MainViewController.h"
#import "HGKOptionPanel.h"
#import "ItemList.h"
#import "MenuListCell.h"
#import "jsonViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MenuList ()

@end

@implementation MenuList
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
    // Do any additional setup after loading the view from its nib.
    allItems = [[NSArray alloc] init];
    displayItems = [[NSMutableArray alloc] init];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
    NSString *str=@"http://localhost/food/categories.php";
    NSURL *url=[NSURL URLWithString:str];
    NSData *myNSData=[NSData dataWithContentsOfURL:url];
    NSError *error=nil;
    allItems = [NSJSONSerialization JSONObjectWithData:myNSData options:kNilOptions error:&error];
    //NSLog(@"%@",allItems);
    
}




-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"The Download could'nt be complete. Please make sure you are connected with 3G or Wi-Fi" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [errorAlert show];
    //Turn Off network Activity Indicatior
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [allItems count];;
}
- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    MenuListCell *cell = (MenuListCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //cell.lableTitle.text = [displayItems objectAtIndex:indexPath.row];
    // cell.lablePrice.text = [displayItems objectAtIndex:indexPath.row];
    // cell.ImageHotDish.image = [UIImage imageNamed:@"about.png"];
    
    NSString *picName = @"file:///Users/malikimran/Desktop/Resturant/RestAutomationAdmin/uploads/category/";
    picName = [picName stringByAppendingString:[[allItems objectAtIndex:indexPath.row] objectForKey:@"image"]];
    [cell.ImageHotDish setImageWithURL:[NSURL URLWithString:picName]
                      placeholderImage:[UIImage imageNamed:nil]];
    
    cell.lableTitle.text = [[allItems objectAtIndex:indexPath.row] objectForKey:@"NAME"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}


- (void)checkButtonTapped:(id)sender event:(id)event
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self->tableView];
    NSIndexPath *indexPath = [self->tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        NSString *alertString = [NSString stringWithFormat:@"Home Many Plate Of : %ld ", (long)indexPath.row];
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"QUANTITY"
                                                       message:alertString
                                                      delegate:nil
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
    NSLog(@"The name is %@",title);
    //NSLog(@"Using the Textfield: %@",[[alertView textFieldAtIndex:0] text]);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ItemList *go1 = [[ItemList alloc] initWithNibName:@"ItemList" bundle:nil];
    //[self presentModalViewController:go1 animated:YES];
    go1.temp = [[allItems objectAtIndex:indexPath.row] objectForKey:@"NAME"];
    [self presentViewController:go1 animated:YES completion:nil];
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
