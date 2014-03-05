//
//  AppDelegate.m
//  NocBible
//
//  Created by Massimiliano Gorreri on 26/09/13.
//  Copyright (c) 2013 Massimiliano Gorreri. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
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
    // Do any additional setup after loading the view.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Upload/Offile"]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        Reachability *reachability = [Reachability reachabilityWithHostName:@"test.newoldcamera.it"];
        
        NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
        
        if(remoteHostStatus == NotReachable) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"NocBible"
                                                              message:@"Nessuna connessione internet disponibile. La connessione internet è necessaria per consultare Noc Camera Bible."
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message  show];
            
        }
    }

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
