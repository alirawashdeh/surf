//
//  EmojiSelectController.h
//  Surf
//
//  Created by Ali Rawashdeh on 30/10/2020.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmojiSelectController : NSViewController

- (void)setClosureCallback:(id)thisObject withSelector:(SEL)thisSelector;
- (void)setLabel:(NSString *)string;
- (NSString*)getLabel;
- (NSString*)getSelectedEmoji;
- (void)backspace;
- (void)down;
- (void)up;

@end

NS_ASSUME_NONNULL_END
