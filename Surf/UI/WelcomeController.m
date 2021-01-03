//
//  WelcomeController.m
//  Surf
//
//  Created by Ali Rawashdeh on 03/01/2021.
//

#import "WelcomeController.h"

@interface WelcomeController ()
@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet NSTabViewItem *preferencesTab;

@end

@implementation WelcomeController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self becomeFirstResponder];
    [[self window] center];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (IBAction)finishClick:(id)sender {
    [self close];
}
- (IBAction)nextClick:(id)sender {
    [_tabView selectTabViewItem:_preferencesTab];
}

@end
