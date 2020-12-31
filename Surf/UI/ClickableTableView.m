//
//  ClickableTableView.m
//  Surf
//
//  Created by Ali Rawashdeh on 14/11/2020.
//

#import "ClickableTableView.h"
#import "Cocoa/Cocoa.h"

@implementation ClickableTableView


id clickCallbackObject;
SEL clickCallback;
BOOL mouseClicked = false;

- (void)setClickCallback:(id)thisObject withSelector:(SEL)thisSelector
{
    clickCallbackObject = thisObject;
    clickCallback = thisSelector;
}


- (BOOL)getClicked {
    return mouseClicked;
}

- (void)setClicked:(BOOL)value {
    mouseClicked = value;
}

- (void)mouseDown:(NSEvent *)theEvent {

    NSPoint globalLocation = [theEvent locationInWindow];
    NSPoint localLocation = [self convertPoint:globalLocation fromView:nil];
    NSInteger clickedRow = [self rowAtPoint:localLocation];

    [super mouseDown:theEvent];

    NSLog(@"row %ld", clickedRow);

    [self deselectAll:Nil];
    mouseClicked = true;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:clickedRow];
    [self selectRowIndexes:indexSet byExtendingSelection:NO];
    [self scrollRowToVisible:[self selectedRow]];

}


@end
