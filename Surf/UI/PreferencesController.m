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
@property (weak) IBOutlet NSButton *launchAtLoginCheckbox;

@end

@implementation PreferencesController

- (void)windowDidLoad {
    [super windowDidLoad];
    [_excludedAppsTextView setString:[Preferences getExcludedAppsText]];
    if([Preferences isLoginLaunchEnabled]){
        [_launchAtLoginCheckbox setState:NSControlStateValueOn];
    }
    else
    {
        [_launchAtLoginCheckbox setState:NSControlStateValueOff];
    }
    [self becomeFirstResponder];
    [[self window] center];
}

- (IBAction)saveButtonClick:(id)sender {
    [Preferences setExcludedApps:[_excludedAppsTextView string]];
    if(_launchAtLoginCheckbox.state == NSControlStateValueOn){
        [Preferences setLoginLaunchEnabled:true];
    }
    else{
        [Preferences setLoginLaunchEnabled:false];
    }
   
    [self close];
}
- (IBAction)cancelButtonClick:(id)sender {
    [self close];
}

@end
