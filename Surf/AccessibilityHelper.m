//
//  SendKeys.m
//  Surf
//
//  Created by Ali Rawashdeh on 30/12/2020.
//

#import <Foundation/Foundation.h>
#import "AccessibilityHelper.h"
#import "EventTap.h"

@implementation AccessibilityHelper

+ (void)returnBackspaceAndCharacterToCursor:(NSString *)emoji label:(NSString*)label {
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
        CGEventPost( kCGAnnotatedSessionEventTap, downEvt );
        CGEventPost( kCGAnnotatedSessionEventTap, upEvt );
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


+ (void)highlightPrevious {

    // shift-left key
    CGEventRef downEvt = CGEventCreateKeyboardEvent( NULL, keyCodeLeftArrow, true );
    CGEventRef upEvt = CGEventCreateKeyboardEvent( NULL, keyCodeLeftArrow, false );
    CGEventSetFlags(downEvt, kCGEventFlagMaskShift);
    CGEventSetFlags(upEvt, kCGEventFlagMaskShift);
    CGEventPost( kCGAnnotatedSessionEventTap, downEvt );
    CGEventPost( kCGAnnotatedSessionEventTap, upEvt );

    CFRelease(downEvt);
    CFRelease(upEvt);
}

+ (void)rightArrow {

    //  right key
    CGEventRef downEvt = CGEventCreateKeyboardEvent( NULL, keyCodeRightArrow, true );
    CGEventRef upEvt = CGEventCreateKeyboardEvent( NULL, keyCodeRightArrow, false );
    CGEventPost( kCGAnnotatedSessionEventTap, downEvt );
    CGEventPost( kCGAnnotatedSessionEventTap, upEvt );

    CFRelease(downEvt);
    CFRelease(upEvt);
}

+ (NSRect)getCursorPosition {
    NSRect textRect = NSZeroRect;
    CFTypeRef system = nil;
    system = AXUIElementCreateSystemWide();
    CFTypeRef application = nil;
    CFTypeRef focusedElement = nil;
    CFRange cfrange;
    AXValueRef rangeValue = nil;
    // Find the currently focused application
    if(AXUIElementCopyAttributeValue(system, kAXFocusedApplicationAttribute, &application) == kAXErrorSuccess)
    {
        // Find the currently focused UI Element
        if(AXUIElementCopyAttributeValue(application, kAXFocusedUIElementAttribute, &focusedElement) == kAXErrorSuccess)
        {

            // Get the range attribute of the selected text (i.e. the cursor position)
            if(AXUIElementCopyAttributeValue(focusedElement, kAXSelectedTextRangeAttribute, (CFTypeRef *)&rangeValue) == kAXErrorSuccess)
            {

                // Get the actual range from the range attribute
                if(AXValueGetValue(rangeValue, kAXValueCFRangeType, (void *)&cfrange))
                {

                    CFTypeRef bounds = nil;
                    textRect = NSZeroRect;
                    if(AXUIElementCopyParameterizedAttributeValue(focusedElement, kAXBoundsForRangeParameterizedAttribute, rangeValue, (CFTypeRef *)&bounds) == kAXErrorSuccess)
                    {
                        CGRect screenRect;
                        AXValueGetValue(bounds, kAXValueCGRectType, &screenRect);
                        if(bounds)
                        {
                            textRect = NSRectFromCGRect(screenRect);
                            //  textRect = [DHAbbreviationManager cocoaRectFromCarbonScreenRect:screenRect];
                            CFRelease(bounds);
                        }
                    }
                }
                if(rangeValue)
                {
                    CFRelease(rangeValue);
                }
            }
        }
        if(focusedElement)
        {
            CFRelease(focusedElement);
        }
    }
    if(application)
    {
        CFRelease(application);
    }
    if(system)
    {
        CFRelease(system);
    }
    return textRect;
}

@end
