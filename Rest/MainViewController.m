//
//  MainViewController.m
//  Food
//
//  Created by Malik Imran on 3/29/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize time;
int hours, minutes, seconds;
int secondsLeft;
NSTimer *timer;
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
    secondsLeft = 16925;
    [self countdownTimer];
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
        secondsLeft = 16925;
    }    // Do any additional setup after loading the view from its nib.
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
