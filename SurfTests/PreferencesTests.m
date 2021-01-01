//
//  SurfTests.m
//  SurfTests
//
//  Created by Ali Rawashdeh on 31/12/2020.
//

#import <XCTest/XCTest.h>
#import "Preferences.h"

@interface PreferencesTests : XCTestCase

@end

@implementation PreferencesTests


- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [Preferences init];
    [Preferences resetPreferences];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [Preferences resetPreferences];
}

- (void)testDefaultPreferences {
    NSString *excludedAppsTest = [Preferences getExcludedAppsText];
    XCTAssertTrue([excludedAppsTest isEqualTo:@"com.tinyspeck.slackmacgap\nWhatsApp\ncom.apple.dt.Xcode"]);
}

- (void)testIsAppExcluded {
    XCTAssertTrue([Preferences isAppExcluded:@"WhatsApp"]);
    XCTAssertFalse([Preferences isAppExcluded:@"NotInTheList"]);
}

- (void)testSettingPreferences {
    [Preferences setExcludedApps:@"test1\ntest2"];
    NSString *excludedAppsTest = [Preferences getExcludedAppsText];
    XCTAssertTrue([excludedAppsTest isEqualTo:@"test1\ntest2"]);
}

@end
