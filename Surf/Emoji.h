//
//  Emoji.h
//  Surf
//
//  Created by Ali Rawashdeh on 24/01/2021.
//
@interface Emoji : NSObject

@property NSString *shortName;
@property NSString *unified;
@property NSString *emojiChar;
@property NSArray *allNames;
@property NSArray *allKeywords;
@property NSDecimalNumber *decimal;
- (void)setEmojiCharFromUnified:(NSString*)code;
- (NSString*)getDisplayString;
- (BOOL)compareTo:(Emoji*)other;
@end
