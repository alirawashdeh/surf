//
//  EmojiTests.m
//  SurfTests
//
//  Created by Ali Rawashdeh on 24/01/2021.
//

#import <XCTest/XCTest.h>
#import "Emoji.h"

@interface EmojiTests : XCTestCase

@end

@implementation EmojiTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testEmoji {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    Emoji *emoji = [Emoji alloc];
    [emoji setUnified:@"1F9B9-200D-2640-FE0F"];
    [emoji setShortName:@"female_supervillain"];
    [emoji setAllNames:@[@"female_supervillain", @"badass"]];
    [emoji setAllKeywords:@[@"criminal", @"evil", @"superpower", @"villain", @"woman", @"woman supervillain"]];
    [emoji setDecimal:[NSDecimalNumber decimalNumberWithString:@"11.0"]];
    XCTAssertEqual(emoji.unified, @"1F9B9-200D-2640-FE0F" );
    XCTAssertEqual(emoji.shortName, @"female_supervillain" );
    XCTAssertEqual(emoji.allNames[1], @"badass" );
    XCTAssertEqual(emoji.allKeywords[1], @"evil" );
    XCTAssertTrue([emoji.decimal compare:[NSDecimalNumber decimalNumberWithString:@"11.0"]] == NSOrderedSame);
    
}


@end
