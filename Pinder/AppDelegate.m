//
//  AppDelegate.m
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <MagicalRecord/MagicalRecord.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "Pinder.h"
#import "PinderServer.h"
#import "AppDelegate.h"

@interface AppDelegate () <PinderServerDelegate>

@end

@implementation AppDelegate

#pragma mark - Pinder

- (void)showError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}

- (void)showErrorMessage:(NSString *)errorMessage
{
    [SVProgressHUD showErrorWithStatus:errorMessage];
}

- (void)showSuccessMessage:(NSString *)successMessage
{
    [SVProgressHUD showSuccessWithStatus:successMessage];
}

#pragma mark - App

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[[Crashlytics class]]];
    [PinderServer sharedServerWithDelegate:self];
    [MagicalRecord setupCoreDataStack];
    
    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeGradient)];
    
    [[PinderServer sharedServer] loadCountries:^(NSArray *arrCountries) {
        NSArray *countries = [FEMDeserializer collectionFromRepresentation:arrCountries mapping:[Country mapping] context:[NSManagedObjectContext MR_defaultContext]];
        NSLog(@"%@ countries loaded", @(countries.count));
        [[PinderServer sharedServer] loadCities:^(NSArray *arrCities) {
            NSArray *cities = [FEMDeserializer collectionFromRepresentation:arrCities mapping:[City mapping] context:[NSManagedObjectContext MR_defaultContext]];
            NSLog(@"%@ cities loaded", @(cities.count));
            [[PinderServer sharedServer] loadUniversities:^(NSArray *arrUnis) {
                NSArray *unis = [FEMDeserializer collectionFromRepresentation:arrUnis mapping:[University mapping] context:[NSManagedObjectContext MR_defaultContext]];
                NSLog(@"%@ universities loaded", @(unis.count));
            }];
        }];
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [MagicalRecord saveWithBlockAndWait:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord saveWithBlockAndWait:nil];
}

@end
