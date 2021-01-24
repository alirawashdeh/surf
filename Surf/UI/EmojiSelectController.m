//
//  EmojiSelectController.m
//  Surf
//
//  Created by Ali Rawashdeh on 30/10/2020.
//

#import "EmojiSelectController.h"
#import "ClickableTableView.h"
#import "DataHelper.h"
#import "Emoji.h"

@interface EmojiSelectController ()

@property (weak) IBOutlet ClickableTableView *tableView;
@property (weak, readwrite) IBOutlet NSTextField *topLabel;

@end

@implementation EmojiSelectController

NSArray *_emojiList;
id closureCallbackObject;
SEL closureCallback;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    _tableView.refusesFirstResponder = TRUE;
    _tableView.rowHeight = NSTableViewRowSizeStyleCustom;
    [_tableView setRowHeight:25];
}

- (NSArray *)emojiList {
    
    if (!_emojiList) {
        [self refreshEmojiList];
    }
    return _emojiList;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    
    if([_tableView getClicked])
    {
        IMP imp = [closureCallbackObject methodForSelector:closureCallback];
        void (*func)(id, SEL) = (void *)imp;
        func(closureCallbackObject, closureCallback);
    }
}

- (void)setClosureCallback:(id)thisObject withSelector:(SEL)thisSelector
{
    closureCallbackObject = thisObject;
    closureCallback = thisSelector;
    [_tableView setClickCallback:self withSelector:@selector(handleClickCallback)];
    
}

- (void)handleClickCallback
{
    IMP imp = [closureCallbackObject methodForSelector:closureCallback];
    void (*func)(id, SEL) = (void *)imp;
    func(closureCallbackObject, closureCallback);
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _emojiList.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return [(Emoji*)[_emojiList objectAtIndex:row] getDisplayString];
}

- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    return NO;
}

-(void)setLabel:(NSString *)string {
    [_topLabel setStringValue:string];
    
    if([string isEqualToString:@":"] || [string isEqualToString:@""]) return;
    [self refreshEmojiList];
    [_tableView reloadData];
    [_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:FALSE];
    [_tableView scrollRowToVisible:[_tableView selectedRow]];
    
}
-(NSString*)getLabel {
    return _topLabel.stringValue;
}

- (void)backspace {
    
    if(_topLabel.stringValue.length > 0)
    {
        _topLabel.stringValue = [ _topLabel.stringValue substringToIndex:[ _topLabel.stringValue length]-1];
        [self refreshEmojiList];
        [_tableView reloadData];
        [_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:FALSE];
    }
}

- (void)down {
    [_tableView setClicked:false];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[_tableView selectedRow]+1];
    [_tableView selectRowIndexes:indexSet byExtendingSelection:NO];
    [_tableView scrollRowToVisible:[_tableView selectedRow]];
}


- (void)up {
    [_tableView setClicked:false];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[_tableView selectedRow]-1];
    [_tableView selectRowIndexes:indexSet byExtendingSelection:NO];
    [_tableView scrollRowToVisible:[_tableView selectedRow]];
}

- (NSString*)getSelectedEmoji {
    
    NSInteger row = [_tableView selectedRow];
    if(row >= 0)
    {
        Emoji *emoji =[_emojiList objectAtIndex:row];
        return emoji.emojiChar;
    }
    return Nil;
}

- (void)refreshEmojiList
{
    [_tableView setClicked:false];
    NSMutableArray *mutableList = [NSMutableArray array];
    
    if((_topLabel != Nil) && (_topLabel.stringValue.length > 0))
    {
        mutableList = [DataHelper getMatchingEmoji:_topLabel.stringValue];
    }
    _emojiList = [NSArray arrayWithArray:mutableList];
}


- (NSString *) leftPadString:(NSString *)s withPadding:(NSString *)padding {
    NSString *padded = [padding stringByAppendingString:s];
    return [padded substringFromIndex:[padded length] - [padding length]];
}

@end
