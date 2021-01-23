//
//  DataHelperTests.m
//  SurfTests
//
//  Created by Ali Rawashdeh on 01/01/2021.
//

#import <XCTest/XCTest.h>
#import "DataHelper.h"
#import "Preferences.h"

@interface DataHelperTests : XCTestCase

@end

@implementation DataHelperTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [DataHelper init];
    [Preferences init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testGetMatchingEmoji {
    NSMutableArray* match = [DataHelper getMatchingEmoji:@":t-rex"];
    XCTAssertTrue([match[0] isEqualTo:@"🦖 :t-rex:"]);
    NSMutableArray* nomatch = [DataHelper getMatchingEmoji:@"asdfasdfasdfdsaadfsa"];
    XCTAssertTrue([nomatch count] == 0);
    NSMutableArray* onecharMatch = [DataHelper getMatchingEmoji:@":"];
    XCTAssertTrue([onecharMatch count] == 0);
    NSMutableArray* spaceMatch = [DataHelper getMatchingEmoji:@":racing car"];
    XCTAssertTrue([spaceMatch[0] isEqualTo:@"🏎️ :racing_car:"]);
    NSMutableArray* dashMatch = [DataHelper getMatchingEmoji:@":racing-car"];
    XCTAssertTrue([dashMatch[0] isEqualTo:@"🏎️ :racing_car:"]);
}


- (void)testUserDefinedKeywords {
    NSMutableArray* match = [DataHelper getMatchingEmoji:@":dino"];
    XCTAssertTrue([match[0] isEqualTo:@"🦖 :t-rex:"]);
}

- (void)testResultOrder {
    NSMutableArray* match = [DataHelper getMatchingEmoji:@":claus"];
    XCTAssertTrue([match[0] isEqualTo:@"🤶 :mrs_claus:"]);
    XCTAssertTrue([match[1] isEqualTo:@"🎅 :santa:"]);
}

@end
