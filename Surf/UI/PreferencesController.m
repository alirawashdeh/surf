//
//  PreferencesController.m
//  Surf
//
//  Created by Ali Rawashdeh on 30/12/2020.
//

#import "PreferencesController.h"
#import "Preferences.h"

@interface PreferencesController ()

@property (unsafe_unretained) IBOutlet NSTextView *excludedAppsTextView;

@end

@implementation PreferencesController

- (void)windowDidLoad {
    [super windowDidLoad];
    [_excludedAppsTextView setString:[Preferences getExcludedAppsText]];
    [self becomeFirstResponder];
    [[self window] center];
}

- (IBAction)saveButtonClick:(id)sender {
    [Preferences setExcludedApps:[_excludedAppsTextView string]];
    [self close];
}
- (IBAction)cancelButtonClick:(id)sender {
    [self close];
}

@end
