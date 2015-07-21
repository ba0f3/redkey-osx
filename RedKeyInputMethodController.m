//
//  InputMethodController.m
//  RedKey
//
//  Created by Bruce Doan on 6/24/15.
//  Copyright (c) 2015 Huy Doan. All rights reserved.
//

#import <dlfcn.h>
#import "RedKeyInputMethodController.h"

void *handle;
char* (*processSequenceTelex)(const char*, const BOOL, const BOOL, const BOOL);
char* (*processSequenceVni)(const char*, const BOOL);

@implementation InputMethodController


-(id)initWithServer:(IMKServer *)server delegate:(id)delegate client:(id<IMKTextInput>)inputClient {
    NSLog(@"initWithServer");
        
    self = [super initWithServer:server delegate:delegate client:inputClient];
    
    handle = dlopen("/Volumes/Data/Projects/bogo-nim/libbogo.dylib", RTLD_LAZY);
    if (!handle) {
        NSLog(@"[%s] main: Unable to open library: %s\n", __FILE__, dlerror());
        exit(EXIT_FAILURE);
    }
    processSequenceTelex =   dlsym(handle, "processSequenceTelex");
    processSequenceVni = dlsym(handle, "processSequenceVni");
    
    
    if (self != nil) {
        cursorPosition = NSNotFound;
        [self reset];
    }
    return self;
}

-(long)calculateSameInitialLength:(NSString*)composing result:(NSString*)string {
    long result = 0;
    
    for (NSInteger i=0; i<composing.length; i++) {
        if(i >= string.length)
            break;
        if([composing characterAtIndex:i] == [string characterAtIndex:i]) {
            result++;
        }
    }
    NSLog(@"calculateSameInitialLength %ld", result);
    return result;
}

-(void)reset {
    NSLog(@"reset");
    composingString = @"";
    originalString = @"";
}

@end

@implementation InputMethodController (IMKStateSetting)

- (NSUInteger)recognizedEvents:(id)sender
{
    return NSKeyDownMask | NSFlagsChangedMask | NSLeftMouseDownMask | NSRightMouseDownMask | NSLeftMouseDraggedMask | NSRightMouseDraggedMask;
}

@end


@implementation InputMethodController (IMKServerInput)

- (BOOL)inputText:(NSString *)string key:(NSInteger)keyCode modifiers:(NSUInteger)flags client:(id<IMKTextInput>)sender {
    NSLog(@"inputText:key:modifiers:client %@ %ld %lu %@", string, (long)keyCode, (unsigned long)flags, [sender uniqueClientIdentifierString]);
    
    if(string == nil || [string length] == 0 || [string characterAtIndex:0] == 0x0d) {
        [self reset];
        return NO;
    }
    
    switch (keyCode) {
        case 49: // space
        case 51: // backspace
        case 76: // enter
            [self reset];
            return NO;
        default:
            break;
    }
    
    originalString = [originalString stringByAppendingString:string];
    
    NSLog(@"originalString %@", originalString);
    
    char* raw = processSequenceVni([originalString UTF8String], TRUE);
    NSString* result = [NSString stringWithCString:raw encoding:NSUTF8StringEncoding];
    
    NSLog(@"Result %@", result);
    
    long sameInitialLength = [self calculateSameInitialLength:composingString result:result];
    long backspace = composingString.length - sameInitialLength;
    
    NSString* stringToCommit = [result substringFromIndex:sameInitialLength];
    NSLog(@"stringToCommit %@", stringToCommit);
    long length = stringToCommit.length;
    
    if (length == 0) {
        return NO;
    }
    long start = [sender length] - backspace;
    
    NSLog(@"Pos start %ld length %ld backspace %ld", start, length, backspace);
    
    [sender insertText:stringToCommit replacementRange: NSMakeRange(start, length)];
    composingString = result;
    return YES;
}
@end


@implementation InputMethodController (IMKMouseHandling)
- (BOOL)mouseDownOnCharacterIndex:(NSUInteger)index coordinate:(NSPoint)point withModifier:(NSUInteger)flags continueTracking:(BOOL *)keepTracking client:(id<IMKTextInput>)sender {
    NSLog(@"mouseDownOn: %lu ", (unsigned long)index);
    [self reset];
    return NO;
}
@end