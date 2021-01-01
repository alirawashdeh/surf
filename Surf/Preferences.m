//
//  Preferences.m
//  Surf
//
//  Created by Ali Rawashdeh on 30/12/2020.
//

#import "Preferences.h"
#import <Foundation/Foundation.h>

NSArray *excludedApps;

@implementation Preferences

+ (void) init {
    excludedApps = [[NSUserDefaults standardUserDefaults] objectForKey:@"ExcludedApps"];
    if(excludedApps == nil){
        [self resetPreferences];
    }
  }

+ (NSString*)getExcludedAppsText{
    
    NSMutableString *outputString = [[NSMutableString alloc]init];
    for (int i = 0; i < [excludedApps count]; i++)
    {
        [outputString appendString:excludedApps[i]];
        if(i < [excludedApps count] -1)
            [outputString appendString:@"\n"];
    }

    return outputString;
}

+ (void)setExcludedApps:(NSString*) string{
   excludedApps = [string componentsSeparatedByString:@"\n"];
   [[NSUserDefaults standardUserDefaults] setObject:excludedApps forKey:@"ExcludedApps"];
}

+ (BOOL)isAppExcluded:(NSString*) appName{
    BOOL result = false;
    for (int i = 0; i < [excludedApps count]; i++)
    {
        if ([appName rangeOfString:excludedApps[i] options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
           result = true;
           break;
       }
    }
    return result;
}


+ (void)resetPreferences{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ExcludedApps"];
    excludedApps = @[@"com.tinyspeck.slackmacgap", @"WhatsApp", @"com.apple.dt.Xcode"];
}

@end
