//
//  PreferencesController.m
//  Surf
//
//  Created by Ali Rawashdeh on 30/12/2020.
//

#import "AboutController.h"

@interface AboutController ()
@property (weak) IBOutlet NSTextField *versionTextField;

@end

@implementation AboutController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self becomeFirstResponder];
    [[self window] center];
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    [_versionTextField setStringValue:[NSString stringWithFormat:@"Version %@", version]];
}

- (IBAction)versionTextField:(id)sender {
}
@end
