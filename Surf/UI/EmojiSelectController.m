//
//  EmojiSelectController.m
//  Surf
//
//  Created by Ali Rawashdeh on 30/10/2020.
//

#import "EmojiSelectController.h"
#import "ClickableTableView.h"

@interface EmojiSelectController ()

@property (weak) IBOutlet ClickableTableView *tableView;
@property (weak, readwrite) IBOutlet NSTextField *topLabel;

@end

@implementation EmojiSelectController

NSArray *_emojiList;
NSDictionary *emojiData;
id closureCallbackObject;
SEL closureCallback;
NSDictionary *dict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    _tableView.refusesFirstResponder = TRUE;
    _tableView.rowHeight = NSTableViewRowSizeStyleCustom;
    [_tableView setRowHeight:25];
    dict = [self JSONFromFile];
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
    return self.emojiList.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return [self.emojiList objectAtIndex:row];
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
        NSString *str = [self emojiList][row];
        NSString *firstWord = [[str componentsSeparatedByString:@" "] objectAtIndex:0];
        return firstWord;
    }
    return Nil;
}

- (void)refreshEmojiList
{
    [_tableView setClicked:false];
    NSMutableArray *mutableList = [NSMutableArray array];
    
    if((_topLabel != Nil) && (_topLabel.stringValue.length > 0))
    {
        for (NSDictionary *item in dict) {
            NSString *name = [item objectForKey:@"short_name"];
            NSString *unified = [item objectForKey:@"unified"];
            NSArray *allNames = [item objectForKey:@"short_names"];
            NSArray *allKeywords = [item objectForKey:@"keywords"];
            NSString *addedIn = [item objectForKey:@"added_in"];
            NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:addedIn];
            if([decimal compare:[NSNumber numberWithInt:13]] == NSOrderedAscending)
            {
                BOOL found = false;
                for (NSString *nameItem in allNames) {
                    {
                        if([nameItem containsString:[_topLabel.stringValue substringFromIndex:1 ]])
                        {
                            found = true;
                        }
                    }
                }
                for (NSString *keyword in allKeywords) {
                    {
                        if([keyword containsString:[_topLabel.stringValue substringFromIndex:1 ]])
                        {
                            found = true;
                        }
                    }
                }
                if(found)
                {
                    NSArray *hexcodes = [unified componentsSeparatedByString:@"-"];
                    NSMutableString *emoji = [NSMutableString stringWithCapacity:50];
                    
                    for(int i = 0; i < [hexcodes count]; i++)
                    {
                        int value = 0;
                        sscanf([hexcodes[i] cStringUsingEncoding:NSUTF8StringEncoding], "%x", &value);
                        uint32_t data = OSSwapHostToLittleInt32(value); // Convert to little-endian
                        NSString *str = [[NSString alloc] initWithBytes:&data length:4 encoding:NSUTF32LittleEndianStringEncoding];
                        [emoji appendString:[NSString stringWithFormat:@"%@",str]];
                    }
                    [mutableList addObject:[NSString stringWithFormat:@"%@ :%@:", emoji,name]];
                }
            }
        }
    }
    
    _emojiList = [NSArray arrayWithArray:mutableList];
}

- (NSDictionary *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emoji-withkeywords" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (NSString *) leftPadString:(NSString *)s withPadding:(NSString *)padding {
    NSString *padded = [padding stringByAppendingString:s];
    return [padded substringFromIndex:[padded length] - [padding length]];
}

@end
