//
//  Emoji.m
//  Surf
//
//  Created by Ali Rawashdeh on 24/01/2021.
//

#import <Foundation/Foundation.h>
#import "Emoji.h"

@implementation Emoji

- (void)setEmojiCharFromUnified:(NSString*)code{
    
    // Convert hex to emoji
    NSArray *hexcodes = [code componentsSeparatedByString:@"-"];
    NSMutableString *emoji = [NSMutableString stringWithCapacity:50];
    for(int i = 0; i < [hexcodes count]; i++)
    {
        int value = 0;
        sscanf([hexcodes[i] cStringUsingEncoding:NSUTF8StringEncoding], "%x", &value);
        uint32_t data = OSSwapHostToLittleInt32(value); // Convert to little-endian
        NSString *str = [[NSString alloc] initWithBytes:&data length:4 encoding:NSUTF32LittleEndianStringEncoding];
        [emoji appendString:[NSString stringWithFormat:@"%@",str]];
    }
    _emojiChar = [NSString stringWithString:emoji];
}

- (NSString*)getDisplayString{
    return [NSString stringWithFormat:@"%@ :%@:", _emojiChar,_shortName];
}

- (BOOL)compareTo:(Emoji*)other{
    if([other.emojiChar isEqualToString:_emojiChar])
    {
        return true;
    }
    return false;
}

@end
