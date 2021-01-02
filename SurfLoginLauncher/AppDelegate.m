//
//  AppDelegate.m
//  SurfLoginLauncher
//
//  Created by Ali Rawashdeh on 02/01/2021.
//

#import "AppDelegate.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{                   
    if ([NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.surf.Surf"].count == 0) {
       [[NSWorkspace sharedWorkspace] launchApplication: @"Surf"];
     }
    else
    {
        NSLog(@"Surf already running");
    }

    [[NSApplication sharedApplication] terminate:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end

