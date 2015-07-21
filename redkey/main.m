//
//  main.m
//  redkey
//
//  Created by Bruce Doan on 7/22/15.
//  Copyright (c) 2015 Huy Doan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <InputMethodKit/InputMethodKit.h>

IMKServer *server = nil;
int main(int argc, const char * argv[]) {
    freopen([@"/tmp/redkey.txt" cStringUsingEncoding:NSASCIIStringEncoding],"a+", stderr);
    
    NSLog(@"RedKey Started");
    
    
    @autoreleasepool {
        NSString *kConnectionName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"InputMethodConnectionName"];
        NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
        
        NSLog(@"%@ %@", kConnectionName, identifier);
        
        server = [[IMKServer alloc] initWithName:kConnectionName bundleIdentifier:identifier];
    
        
        
        [[NSBundle mainBundle] loadNibNamed:@"MainMenu" owner:[NSApplication sharedApplication] topLevelObjects:nil];
        
        // Run everything
        [[NSApplication sharedApplication] run];
    }
    return 0;
}