//
//  AppDelegate.m
//  Surf
//
//  Created by Ali Rawashdeh on 30/10/2020.
//

#import "AppDelegate.h"
#import "EmojiSelectController.h"
#import "EventTap.h"
#import "PreferencesController.h"
#import "AboutController.h"
#import <Foundation/Foundation.h>
#import "Preferences.h"
#import "AccessibilityHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

NSStatusItem *statusItem;
NSPopover *popover;
Boolean shown = FALSE;

NSWindow* window;
EmojiSelectController *myView;
AboutController *aboutWindowController;
PreferencesController *preferencesWindowController;

BOOL lastKeyPressColon = false;
pid_t pid;
EventTap *tap;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    if(AXIsProcessTrusted() == false)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSAlertStyleCritical];
        [alert setMessageText:@"Turn on accessibility"];
        [alert setInformativeText:@"Surf needs accessibility permissions to work. Select the Surf checkbox in in Security & Privacy > Accessibility."];
        [alert addButtonWithTitle:@"Turn on accessibility"];
        [alert runModal];

        NSString* prefPage = @"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility";
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:prefPage]];
    }
    
    [self checkAccessibilityAndInitialise];
    
}

- (void)checkAccessibilityAndInitialise
{
    if(AXIsProcessTrusted() == false)
    {
        [self performSelector:@selector(checkAccessibilityAndInitialise) withObject:NULL afterDelay:1.0];
    }
    else
    {
        tap = [[EventTap alloc] initWithCallback:self withSelector:@selector(keypress:)];
        [tap enable];

        window = [[NSWindow alloc] initWithContentRect:NSZeroRect styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:NO];
        [Preferences init];
        [self createStatusBarIconAndMenu];

        myView = [[EmojiSelectController alloc]
                  initWithNibName:@"EmojiPopover"
                  bundle:Nil];
        [myView setClosureCallback:self withSelector:@selector(closeAndReturnEmoji)];
        [myView setLabel:@":"];
        [myView view];
        popover = [[NSPopover alloc] init];
        popover.contentViewController = myView;
        popover.animates = false;
    }
}


- (void)quit{
    exit(0);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)createStatusBarIconAndMenu {
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    statusItem = [statusBar statusItemWithLength:NSSquareStatusItemLength];

    NSImage *icon = [NSImage imageNamed:@"icon"];

    statusItem.button.image = icon;
    statusItem.menu = [self createStatusBarMenu];
}

- (NSMenu *)createStatusBarMenu {
    NSMenu *menu = [[NSMenu alloc] init];

    NSMenuItem *quit =
      [[NSMenuItem alloc] initWithTitle:@"Quit"
                                 action:@selector(quit)
                          keyEquivalent:@""];
    [quit setTarget:self];

    NSMenuItem *about =
      [[NSMenuItem alloc] initWithTitle:@"About Surf"
                                 action:@selector(showAboutWindow)
                          keyEquivalent:@""];
    [about setTarget:self];
    
    
    NSMenuItem *preferences =
      [[NSMenuItem alloc] initWithTitle:@"Preferences"
                                 action:@selector(showPreferencesWindow)
                          keyEquivalent:@""];
    [about setTarget:self];
    
    [menu addItem:preferences];
    [menu addItem:about];
    [menu addItem:quit];
    return menu;
}

-(void)showAboutWindow{
    if( aboutWindowController == nil )
    {
        aboutWindowController = [[AboutController alloc] initWithWindowNibName:@"About"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aboutWindowClose:) name:NSWindowWillCloseNotification object:aboutWindowController.window];
    }
    [aboutWindowController.window makeKeyAndOrderFront:self];
    [aboutWindowController showWindow:self];
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
}

- (void)aboutWindowClose:(NSNotification *)notification
{
    aboutWindowController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowWillCloseNotification object:window];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
}
    
-(void)showPreferencesWindow{
    if( preferencesWindowController == nil )
    {
        preferencesWindowController = [[PreferencesController alloc] initWithWindowNibName:@"Preferences"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferencesWindowClose:) name:NSWindowWillCloseNotification object:preferencesWindowController.window];
    }
    [preferencesWindowController.window makeKeyAndOrderFront:self];
    [preferencesWindowController showWindow:self];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)preferencesWindowClose:(NSNotification *)notification
{
    preferencesWindowController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowWillCloseNotification object:window];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
}

-(BOOL)keypress:(NSEvent *)nsevent {

    NSString *chars = [[nsevent characters] lowercaseString];
    unichar character = [chars characterAtIndex:0];

    if(shown)
    {
        switch (nsevent.keyCode) {

        case keyCodeTab:
            if([nsevent modifierFlags] & NSEventModifierFlagCommand )
            {
                [self closeWithoutReturningEmoji];
                return true;  // suppress
            }
            else
            {
                [self closeAndReturnEmoji];
                return true;  // suppress
            }
            break;
            case keyCodeReturn:
            case keyCodeKeypadEnter:
                [self closeAndReturnEmoji];
                return true;  // suppress
                break;
            case keyCodeEscape:
            case keyCodeLeftArrow:
            case keyCodeRightArrow:
                [self closeWithoutReturningEmoji];
                return true; // suppress
                break;
            case keyCodeDelete:
                [myView backspace];
                if([myView getLabel].length == 0)
                {
                    [self closeWithoutReturningEmoji];
                }
                break;
            case keyCodeDownArrow:
                [myView down];
                return true; // suppress
                break;
            case keyCodeUpArrow:
                [myView up];
                return true; // suppress
                break;
            default:
                [myView setLabel:[NSString stringWithFormat:@"%@%@", [myView getLabel], chars]];
                break;
        }
    }
    else
    {
        if(character == ':')
        {
            lastKeyPressColon = true;
        }
        else
        {
            if(lastKeyPressColon)
            {
                lastKeyPressColon = false;
                switch (nsevent.keyCode) {
                    case keyCodeReturn:
                    case keyCodeKeypadEnter:
                    case keyCodeDelete:
                    case keyCodeSpace:
                    case keyCodeTab:
                        break;
                    default:
                        if ([Preferences isAppExcluded:[self getFrontmostApp]])
                            return false;
                        [tap pause];
                        [AccessibilityHelper highlightPrevious];

                        NSRect textRect = [AccessibilityHelper getCursorPosition];

                        [AccessibilityHelper rightArrow];
                        [tap resume];
                        [myView setLabel:[NSString stringWithFormat:@":%@", chars]];
                        popover.behavior = NSPopoverBehaviorTransient;

                        NSRect rect = NSMakeRect(textRect.origin.x, [[[NSScreen screens] objectAtIndex:0] frame].size.height - textRect.origin.y - 20, textRect.size.width, textRect.size.height);
                        NSRectEdge edge = NSRectEdgeMinY;

                        if(textRect.size.width == 0)
                        {
                            //Accessibility not available in the current app, so centre the window instead.
                            rect = [self getRectForCenterOfScreen];
                            //Set the popover to align to the top edgde
                            edge = NSRectEdgeMaxY;
                        }

                        [window setFrame: rect display: YES animate: FALSE];
                        window.opaque = NO;
                        window.backgroundColor = [NSColor clearColor];
                        window.level = NSStatusWindowLevel;
                        window.accessibilityHidden = YES;
                        [window makeFirstResponder:Nil];
                        [window makeKeyAndOrderFront:nil];
     
                        [popover showRelativeToRect:NSZeroRect ofView:window.contentView preferredEdge:edge];
                        NSApp.activationPolicy = NSApplicationActivationPolicyProhibited;

                        shown = true;
                        
                        break;
                }
            }
        }
    }
    return false;
}

- (NSRect) getRectForCenterOfScreen
{
    NSWindow * window = NSApplication.sharedApplication.windows[0];
    CGFloat xPos = NSWidth(window.screen.frame)/2 - NSWidth(window.frame)/2;
    CGFloat yPos = NSHeight(window.screen.frame)/2 - NSHeight(window.frame)/2;
    NSRect rect = NSMakeRect(xPos, yPos, NSWidth(window.frame), NSHeight(window.frame));
    return rect;
}

- (NSString*) getFrontmostApp {
        NSRunningApplication* runningApp = [[NSWorkspace sharedWorkspace] frontmostApplication];
        return runningApp.bundleIdentifier;
}

- (void) closeAndReturnEmoji {
    [popover close];
    shown = false;
    if([myView getSelectedEmoji])
    {
        [tap pause];
        [AccessibilityHelper returnBackspaceAndCharacterToCursor:[myView getSelectedEmoji] label:[myView getLabel]];
        [tap resume];
    }
}

- (void) closeWithoutReturningEmoji {
        [popover close];
        shown = false;
}

@end
