#import "EventTap.h"

@interface EventTap (Private)

// The event tap receives the key up events.
- (void)createEventTap;
- (void)pauseEventTap;
- (void)resumeEventTap;

// Remove when we don't need it anymore (and before exiting).
- (void)destroyEventTap;

// This function is called when an event occurrs which we're tapping.
CGEventRef MyEventTapCallBack (CGEventTapProxy proxy,
							   CGEventType type,
							   CGEventRef event,
							   void *refcon);

@end


@implementation EventTap

id callbackObject;
SEL callback;
NSRegularExpression *regex;

- (id) init {
	self = [super init];
	if (self != nil) {	
		_ref = NULL;
	}
    
    regex = [[NSRegularExpression alloc]
      initWithPattern:@"[a-zA-Z0-9 ./<>?;:""'`!@#$%^&*()\\[\\]{}_+=|\\-]" options:0 error:NULL];
   
	return self;
}

- (id)initWithCallback:(id)thisObject withSelector:(SEL)thisSelector
{
    callbackObject = thisObject;
    callback = thisSelector;
    return [self init];
}

- (void) dealloc {
	[self disable];
}

- (void)enable {
	[self createEventTap];
}

- (void)pause {
    [self pauseEventTap];
}

- (void)resume {
    [self resumeEventTap];
}

- (void)disable {
	[self destroyEventTap];
}

- (CGEventRef)keyEventReceived:(CGEventRef)event {
	// This method should be as efficient as possible since it will be called every time the 
	// user types a key on their keyboard!  It's not quite as efficient as I'd like at this point,
	// but it doesn't appear to slow things down...
    NSEvent *nsevent = [NSEvent eventWithCGEvent:event];
	NSString * chars = [nsevent characters];
    
    // Don't know how to handle this case, so just abort.
	if ([chars length] != 1) return event;
    
    // Detect if the keypress if for a character we want to handle
    BOOL characterPressed = false;
    NSUInteger matches = [regex numberOfMatchesInString:chars options:0
      range:NSMakeRange(0, [chars length])];
    if (matches > 0) {
        characterPressed = true;
    }
    
    // left, right, escape, enter, return, backspace, tab, alpha
    if((nsevent.keyCode == keyCodeLeftArrow) || (nsevent.keyCode == keyCodeRightArrow) || (nsevent.keyCode == keyCodeDownArrow) || (nsevent.keyCode == keyCodeUpArrow) || (nsevent.keyCode == keyCodeReturn) || (nsevent.keyCode == keyCodeEscape) || (nsevent.keyCode == keyCodeKeypadEnter) || (nsevent.keyCode == keyCodeDelete) || (nsevent.keyCode == keyCodeTab) || characterPressed){
    
        if ([callbackObject respondsToSelector:callback])
            {
                IMP imp = [callbackObject methodForSelector:callback];
                BOOL (*func)(id, SEL, NSEvent*) = (void *)imp;
                BOOL suppress  = func(callbackObject, callback, nsevent);
                                      
                // BOOL suppress = (BOOL)[callbackObject performSelector:callback withObject:nsevent];
                if(suppress)
                {
                    return NULL;
                }
            }
            return event;
    }

    return event;
}

- (void)createEventTap {

	// What events should we listen for?
	CGEventMask mask = CGEventMaskBit(kCGEventKeyDown);
	
	_ref = CGEventTapCreate(kCGAnnotatedSessionEventTap,
                            kCGHeadInsertEventTap,
                            kCGEventTapOptionDefault,
							mask,
							MyEventTapCallBack, 
                            (__bridge void * _Nullable)(self));
	
    CFRunLoopSourceRef sourceRef = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, _ref, 0);
	
	NSRunLoop * loop = [NSRunLoop mainRunLoop];
	CFRunLoopAddSource([loop getCFRunLoop], sourceRef, kCFRunLoopCommonModes);
}

- (void)pauseEventTap {
    CGEventTapEnable(_ref, false);
}

- (void)resumeEventTap {
    CGEventTapEnable(_ref, true);
}

// Callback for the event tap which is called every time the user types a key.
CGEventRef MyEventTapCallBack (CGEventTapProxy proxy,
							   CGEventType type,
							   CGEventRef event,
							   void *refcon) {
   
    if((type > 0) && (type <= 0x7fffffff))
    {
    return [(__bridge EventTap*)refcon keyEventReceived:event];
    }
    else
    {
        return event;
    }
}

- (void)destroyEventTap {
	if (_ref) {
		
		CFRunLoopSourceRef sourceRef = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, _ref, 0);
		
		NSRunLoop * loop = [NSRunLoop mainRunLoop];
		CFRunLoopRemoveSource([loop getCFRunLoop], sourceRef, kCFRunLoopCommonModes);

		CFRelease(_ref);
		_ref = NULL;
	}
}

@end
