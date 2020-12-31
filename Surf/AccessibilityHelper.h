//
//  SendKeys.h
//  Surf
//
//  Created by Ali Rawashdeh on 30/12/2020.
//

#import <Foundation/Foundation.h>

@interface AccessibilityHelper : NSObject

+ (void)returnBackspaceAndCharacterToCursor:(NSString *) emoji label:(NSString*)label;
+ (void)highlightPrevious;
+ (void)rightArrow;
+ (NSRect)getCursorPosition;


@end
