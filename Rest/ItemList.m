#import "ItemList.h"
#import "HotDishes.h"
#import "HomeMenuCell.h"
#import "HotDishCell.h"
#import "Home.h"
#import "ItemListCell.h"
#import "OrderPage.h"
#import "MyOrder.h"
#import "MenuList.h"
#import "MainViewController.h"
#import "HGKOptionPanel.h"
#import "jsonViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ItemList ()

@end

@implementation ItemList
@synthesize back;
@synthesize home;
@synthesize temp;
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
    NSString *title = [NSString stringWithFormat:@"%@", temp];
    _titleText.text = title;
    [self setNeedsStatusBarAppearanceUpdate];
    [back addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [home addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    allItems = [[NSMutableArray alloc] init];
    displayItems = [[NSMutableArray alloc] init];
    
    NSString *str=@"http://localhost/food/plist.php?name=";
    str = [str stringByAppendingString:title];
    NSString* urlTextEscaped = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *url=[NSURL URLWithString:urlTextEscaped];
    NSData *myNSData=[NSData dataWithContentsOfURL:url];
    NSError *error=nil;
    NSMutableDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:myNSData options: NSJSONReadingMutableContainers error:NULL];
    allItems = responseDictionary;
    displayItems = [NSJSONSerialization JSONObjectWithData:myNSData options:kNilOptions error:&error];
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
    
    ItemListCell *cell = (ItemListCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ItemListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSString *picName = @"file:///Users/malikimran/Desktop/Resturant/RestAutomationAdmin/uploads/dish/";
    picName = [picName stringByAppendingString:[[allItems objectAtIndex:indexPath.row] objectForKey:@"picture"]];
    [cell.ImageHotDish setImageWithURL:[NSURL URLWithString:picName]
                      placeholderImage:[UIImage imageNamed:nil]];
    
    cell.lableTitle.text = [[allItems objectAtIndex:indexPath.row] objectForKey:@"NAME"];
    cell.lablePrice.text = [[allItems objectAtIndex:indexPath.row] objectForKey:@"price"];
    
    [cell.buttonAdd addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}


- (void)checkButtonTapped:(id)sender event:(id)event
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self->tableView];
    NSIndexPath *indexPath = [self->tableView indexPathForRowAtPoint:buttonPosition];
    NSLog(@"P ID = %@", [[allItems objectAtIndex:indexPath.row] objectForKey:@"id"]);
    proIDs =[[allItems objectAtIndex:indexPath.row] objectForKey:@"id"];
    time =[[allItems objectAtIndex:indexPath.row] objectForKey:@"average_cooking_time_min"];
    if (indexPath != nil)
    {
        NSString *alertString = [NSString stringWithFormat:@"Home Many Plate Of : %@ ",[[allItems objectAtIndex:indexPath.row] objectForKey:@"NAME"]];
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
        //NSString *dishId = [[allItems objectAtIndex:buttonIndex] objectForKey:@"id"];
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderPage *go1 = [[OrderPage alloc] initWithNibName:@"OrderPage" bundle:nil];
    go1.temp = [[allItems objectAtIndex:indexPath.row] objectForKey:@"id"];
    [self presentViewController:go1 animated:YES completion:nil];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)asearchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)asearchBar textDidChange:(NSString *)searchText{
    if ([searchText length] == 0) {
        [allItems removeAllObjects];
        [allItems addObjectsFromArray:displayItems];
        [searchBar performSelector: @selector(resignFirstResponder)
                        withObject: nil
                        afterDelay: 0.1];
    }
    else{
        if([allItems count] >= 1){
            [allItems removeAllObjects];
        }
        //[allItems removeAllObjects];
        NSString *string;
        int i=0;
        for (string in displayItems) {
            
            string = [string valueForKey:@"NAME"];
            NSRange r = [string rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (r.location != NSNotFound) {
                [allItems addObject:[displayItems objectAtIndex:i]];
            }
            i = i+1;
        }
    }
    [tableView reloadData];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)aSearchBar{
    [searchBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonPressed:(UIButton *)sender
{
    MenuList *go1 = [[MenuList alloc] initWithNibName:@"MenuList" bundle:nil];
    [self presentViewController:go1 animated:YES completion:nil];
}

@end
