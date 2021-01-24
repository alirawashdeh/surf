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

- (void)testBaseEmoji {
    Emoji *emoji = [Emoji alloc];
    [emoji setUnified:@"1F9B9-200D-2640-FE0F"];
    [emoji setShortName:@"female_supervillain"];
    [emoji setAllShortNames:@[@"female_supervillain", @"badass"]];
    [emoji setKeywords:@[@"criminal", @"evil", @"superpower", @"villain", @"woman", @"woman supervillain"]];
    [emoji setVersion:[NSDecimalNumber decimalNumberWithString:@"11.0"]];
    XCTAssertEqual(emoji.unified, @"1F9B9-200D-2640-FE0F" );
    XCTAssertEqual(emoji.shortName, @"female_supervillain" );
    XCTAssertEqual(emoji.allShortNames[1], @"badass" );
    XCTAssertEqual(emoji.keywords[1], @"evil" );
    XCTAssertTrue([emoji.version compare:[NSDecimalNumber decimalNumberWithString:@"11.0"]] == NSOrderedSame);
}

- (void)testEmojiChar {
    Emoji *emoji = [Emoji alloc];
    [emoji setUnified:@"1F9B9-200D-2640-FE0F"];
    [emoji setEmojiCharFromUnified:emoji.unified];
    XCTAssertTrue([emoji.emojiChar isEqualToString:@"🦹‍♀️"]);
}

- (void)testGetDisplayString {
    Emoji *emoji = [Emoji alloc];
    [emoji setUnified:@"1F9B9-200D-2640-FE0F"];
    [emoji setEmojiCharFromUnified:emoji.unified];
    [emoji setShortName:@"female_supervillain"];
    XCTAssertTrue([[emoji getDisplayString] isEqualToString:@"🦹‍♀️ :female_supervillain:"]);
}

- (void)testCompare {
    Emoji *emoji1 = [Emoji alloc];
    [emoji1 setUnified:@"1F9B9-200D-2640-FE0F"];
    [emoji1 setShortName:@"female_supervillain"];
    [emoji1 setAllShortNames:@[@"female_supervillain", @"badass"]];
    [emoji1 setKeywords:@[@"criminal", @"evil", @"superpower", @"villain", @"woman", @"woman supervillain"]];
    [emoji1 setVersion:[NSDecimalNumber decimalNumberWithString:@"11.0"]];
    [emoji1 setEmojiCharFromUnified:emoji1.unified];
    [emoji1 setShortName:@"female_supervillain"];
    
    Emoji *emoji2 = [Emoji alloc];
    [emoji2 setUnified:@"1F9B9-200D-2640-FE0F"];
    [emoji2 setShortName:@"female_supervillain"];
    [emoji2 setAllShortNames:@[@"female_supervillain", @"badass"]];
    [emoji2 setKeywords:@[@"criminal", @"evil", @"superpower", @"villain", @"woman", @"woman supervillain"]];
    [emoji2 setVersion:[NSDecimalNumber decimalNumberWithString:@"11.0"]];
    [emoji2 setEmojiCharFromUnified:emoji2.unified];
    [emoji2 setShortName:@"female_supervillain"];
    
    Emoji *emoji3 = [Emoji alloc];
    [emoji3 setUnified:@"1F9B9-200D-2642-FE0F"];
    [emoji3 setShortName:@"male_supervillain"];
    [emoji3 setAllShortNames:@[@"male_supervillain", @"badass"]];
    [emoji3 setKeywords:@[@"criminal", @"evil", @"superpower", @"villain", @"man", @"man supervillain"]];
    [emoji3 setVersion:[NSDecimalNumber decimalNumberWithString:@"11.0"]];
    [emoji3 setEmojiCharFromUnified:emoji3.unified];
    [emoji3 setShortName:@"male_supervillain"];
    
    XCTAssertTrue([emoji1 compareTo:emoji2]);
    XCTAssertFalse([emoji1 compareTo:emoji3]);
}

@end
