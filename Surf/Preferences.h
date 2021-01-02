//
//  Preferences.h
//  Surf
//
//  Created by Ali Rawashdeh on 30/12/2020.
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject

+ (NSString*)getExcludedAppsText;
+ (void)setExcludedApps:(NSString*) string;
+ (BOOL)isAppExcluded:(NSString*) appName;
+ (void)init;
+ (void)resetPreferences;
+ (void)setLoginLaunchEnabled:(BOOL) value;
+ (BOOL)isLoginLaunchEnabled;
@end
