//
//  ClickableTableView.h
//  Surf
//
//  Created by Ali Rawashdeh on 14/11/2020.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClickableTableView : NSTableView

- (BOOL)getClicked;
- (void)setClicked:(BOOL)value;
- (void)setClickCallback:(id)thisObject withSelector:(SEL)thisSelector;

@end

NS_ASSUME_NONNULL_END
