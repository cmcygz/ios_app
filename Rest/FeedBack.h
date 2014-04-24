//
//  FeedBack.h
//  Rest
//
//  Created by Malik Imran on 4/22/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"

@interface FeedBack : UIViewController <StarRatingViewDelegate>{
    NSString *dateStr;
    __weak IBOutlet UIButton *back;
    __weak IBOutlet UIButton *home;
}
@property (nonatomic, weak) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *home;
@property (nonatomic,strong)TQStarRatingView *starRatingView;
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) IBOutlet UITextView *comment_area;
- (IBAction)buttonPostFeedBack:(id)sender;

@end
