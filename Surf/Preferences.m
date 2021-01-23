//
//  Preferences.m
//  Surf
//
//  Created by Ali Rawashdeh on 30/12/2020.
//

#import "Preferences.h"
#import <Foundation/Foundation.h>
#import <ServiceManagement/ServiceManagement.h>

NSArray *excludedApps;
NSMutableDictionary *userDefinedKeywords;
BOOL launchAtLogin;

@implementation Preferences

+ (void) init {
    excludedApps = [[NSUserDefaults standardUserDefaults] objectForKey:@"ExcludedApps"];
    if(excludedApps == nil){
        [self resetExcludedApps];
    }
    userDefinedKeywords = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserDefinedKeywords"];
    if(userDefinedKeywords == nil){
        [self resetUserDefinedKeywords];
    }
    launchAtLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"LaunchAtLogin"];
  }

+ (void)resetPreferences{
    [self resetExcludedApps];
    [self resetUserDefinedKeywords];
    [self setLoginLaunchEnabled:true];
  
}

+ (void)resetExcludedApps{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ExcludedApps"];
    excludedApps = @[@"com.tinyspeck.slackmacgap", @"WhatsApp", @"com.apple.dt.Xcode"];
    
}
+ (void)resetUserDefinedKeywords{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserDefinedKeywords"];
    userDefinedKeywords = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           @"rubbish", @"🗑️",
                           @"dino",@"🦖",
                           @"klaxon",@"🚨",
                           nil];
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

+ (BOOL)isLoginLaunchEnabled{
    return launchAtLogin;
}

+ (void)setLoginLaunchEnabled:(BOOL) value{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"LaunchAtLogin"];
    SMLoginItemSetEnabled((__bridge CFStringRef)@"com.surf.SurfLoginLauncher", value);
    launchAtLogin = value;
}

+ (NSDictionary*)getUserDefinedKeywords{
    return userDefinedKeywords;
}

+ (NSString*)getUserDefinedKeywordsAsText{
    NSMutableString *outputString = [[NSMutableString alloc]init];
    for (int i = 0; i < [userDefinedKeywords.allKeys count]; i++)
    {
        [outputString appendString:userDefinedKeywords.allKeys[i]];
        [outputString appendString:@","];
        [outputString appendString:[userDefinedKeywords objectForKey:userDefinedKeywords.allKeys[i]]];
        if(i < [userDefinedKeywords.allKeys count] -1)
            [outputString appendString:@"\n"];
    }

    return outputString;
}

+ (void)setUserDefinedKeywords:(NSString*) string{
    
    userDefinedKeywords = [[NSMutableDictionary alloc] init];
    NSArray *rows = [string componentsSeparatedByString:@"\n"];
    for (int i = 0; i < [rows count]; i++)
    {
        NSArray *values = [rows[i] componentsSeparatedByString:@","];
        if([values count] == 2)
        {
            [userDefinedKeywords setObject:values[1] forKey:values[0]];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:userDefinedKeywords forKey:@"UserDefinedKeywords"];

}


@end
