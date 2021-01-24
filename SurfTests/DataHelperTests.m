//
//  DataHelperTests.m
//  SurfTests
//
//  Created by Ali Rawashdeh on 01/01/2021.
//

#import <XCTest/XCTest.h>
#import "DataHelper.h"
#import "Preferences.h"
#import "Emoji.h"

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
    Emoji* resultToCheck;
    NSMutableArray* match = [DataHelper getMatchingEmoji:@":t-rex"];
    resultToCheck = match[0];
    XCTAssertTrue([[resultToCheck getDisplayString] isEqualTo:@"🦖 :t-rex:"]);
    NSMutableArray* nomatch = [DataHelper getMatchingEmoji:@"asdfasdfasdfdsaadfsa"];
    XCTAssertTrue([nomatch count] == 0);
    NSMutableArray* onecharMatch = [DataHelper getMatchingEmoji:@":"];
    XCTAssertTrue([onecharMatch count] == 0);
    NSMutableArray* spaceMatch = [DataHelper getMatchingEmoji:@":racing car"];
    resultToCheck = spaceMatch[0];
    XCTAssertTrue([[resultToCheck getDisplayString] isEqualTo:@"🏎️ :racing_car:"]);
    NSMutableArray* dashMatch = [DataHelper getMatchingEmoji:@":racing-car"];
    resultToCheck = dashMatch[0];
    XCTAssertTrue([[resultToCheck getDisplayString] isEqualTo:@"🏎️ :racing_car:"]);
}


- (void)testUserDefinedKeywords {
    Emoji* resultToCheck;
    NSMutableArray* match = [DataHelper getMatchingEmoji:@":dino"];
    resultToCheck = match[0];
    XCTAssertTrue([[resultToCheck getDisplayString] isEqualTo:@"🦖 :t-rex:"]);
}

- (void)testResultOrder {
    Emoji* resultToCheck;
    Emoji* resultToCheck2;
    NSMutableArray* match = [DataHelper getMatchingEmoji:@":claus"];
    resultToCheck = match[0];
    resultToCheck2 = match[1];
    XCTAssertTrue([[resultToCheck getDisplayString] isEqualTo:@"🤶 :mrs_claus:"]);
    XCTAssertTrue([[resultToCheck2 getDisplayString] isEqualTo:@"🎅 :santa:"]);
}

- (void)testDeDuplication {
    NSMutableArray* matches = [DataHelper getMatchingEmoji:@":villain"];
    XCTAssertEqual(matches.count,3); //🦹‍♀️🦹‍♂️🦹
}

@end
