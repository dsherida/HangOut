//
//  HangOutAppDelegate.m
//  HangOut
//
//  Created by Doug Sheridan on 2/24/14.
//
//

#import "HangOutAppDelegate.h"

@implementation HangOutAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Parse initialization
    [Parse setApplicationId:@"aKgiFXpgCls4fAnPDJV2qJWN0ciYs0Etkv2JXXuO"
                  clientKey:@"BvWeN8gu0hjdxR2BzsA1QWdeMN8nTR3qkB7hSKmC"];
    
    // Track statistics around application opens
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Facebook initialization
    [PFFacebookUtils initializeFacebook];
    
    // Override point for customization after application launch.
    return YES;
}


// Single sign-on feature for Facebook SDK
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
    // More Facebook initialization
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
