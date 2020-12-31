//
//  SendKeys.m
//  Surf
//
//  Created by Ali Rawashdeh on 30/12/2020.
//

#import <Foundation/Foundation.h>
#import "AccessibilityHelper.h"

@implementation AccessibilityHelper

+ (void)returnBackspaceAndCharacterToCursor:(NSString *)emoji label:(NSString*)label {

    NSLog(@"getting emoji");

    NSLog(@"output emoji: %@", emoji);
    // 1 - Get the string length in bytes.
    NSUInteger l = [emoji lengthOfBytesUsingEncoding:NSUTF16StringEncoding];

    // 2 - Get bytes for unicode characters
    UniChar *uc = malloc(l);
    [emoji getBytes:uc maxLength:l usedLength:NULL encoding:NSUTF16StringEncoding options:0 range:NSMakeRange(0, l) remainingRange:NULL];

    // 3 - create an empty tap event, and set unicode string
    CGEventRef downEvt = CGEventCreateKeyboardEvent( NULL, 0, true );
    CGEventRef upEvt = CGEventCreateKeyboardEvent( NULL, 0, false );

    // Send backspace
    UniChar chars[3];
    chars[0] = '\b';
    CGEventKeyboardSetUnicodeString(downEvt, 1, chars);
    CGEventKeyboardSetUnicodeString(upEvt, 1, chars);

    for (int i = 0; i < label.length; i++){
        //
        CGEventPost( kCGAnnotatedSessionEventTap, downEvt );
        CGEventPost( kCGAnnotatedSessionEventTap, upEvt );
        //        CGEventPostToPSN (&pid,downEvt);
        //        CGEventPostToPSN (&pid,upEvt);
    }

    // send strings
    CGEventKeyboardSetUnicodeString(downEvt, emoji.length, uc);
    CGEventKeyboardSetUnicodeString(upEvt, emoji.length, uc);
    CGEventPost( kCGAnnotatedSessionEventTap, downEvt );
    CGEventPost( kCGAnnotatedSessionEventTap, upEvt );

    CFRelease(downEvt);
    CFRelease(upEvt);
    free(uc);
}


@end
