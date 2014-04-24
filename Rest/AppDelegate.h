//
//  AppDelegate.h
//  Rest
//
//  Created by Malik Imran on 4/1/14.
//  Copyright (c) 2014 Malik.Imran. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
// Declare variable to be used outside the layer here
@property (strong, nonatomic) NSString *passUdid;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;
@end