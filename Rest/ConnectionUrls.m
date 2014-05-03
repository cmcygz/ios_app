//
//  ConnectionUrls.m
//  Rest
//
//  Created by Malik Imran on 5/3/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//

#import "ConnectionUrls.h"


@implementation ConnectionUrls

+(NSInteger)getScreenHeight
{
    NSInteger screenHeight;
    if ([[UIScreen mainScreen] bounds].size.height==568.0) {
        screenHeight = 550;
    }
    else
    {
        screenHeight = 460;
    }
    
    return screenHeight;
}

@end
