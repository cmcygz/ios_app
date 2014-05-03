//
//  jsonViewController.m
//  Food
//
//  Created by Malik Imran on 4/1/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import "jsonViewController.h"
#import "ConnectionUrls.h"
@interface jsonViewController ()

@end

@implementation jsonViewController
@synthesize titlelabel;
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
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)getDataFromJson:(id)sender {
    NSString *str=Hot_Dish;
    NSURL *url=[NSURL URLWithString:str];
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSError *error=nil;
    id response=[NSJSONSerialization JSONObjectWithData:data options:
                 NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"Your JSON Object: %@ Or Error is: %@", response, error);}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
