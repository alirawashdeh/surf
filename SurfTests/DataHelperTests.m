//
//  DataHelperTests.m
//  SurfTests
//
//  Created by Ali Rawashdeh on 01/01/2021.
//

#import <XCTest/XCTest.h>
#import "DataHelper.h"

@interface DataHelperTests : XCTestCase

@end

@implementation DataHelperTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [DataHelper init];
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
}

- (void)testResultOrder {
    NSMutableArray* match = [DataHelper getMatchingEmoji:@":claus"];
    XCTAssertTrue([match[0] isEqualTo:@"🤶 :mrs_claus:"]);
    XCTAssertTrue([match[1] isEqualTo:@"🎅 :santa:"]);
}

@end
