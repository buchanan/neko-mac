//
//  main.m
//  猫
//
//  Created by Matthew Donoughe on 2007-09-23.
//  Copyright __MyCompanyName__ 2007. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyPanel.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (nonatomic, strong) NSWindow *window;
@end

@implementation AppDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.window = [[MyPanel alloc] initWithContentRect:NSMakeRect(0, 0, 32, 32)
                                                 styleMask:NSWindowStyleMaskBorderless
                                                   backing:NSBackingStoreBuffered
                                                     defer:NO];
}
@end

int main(int argc, char *argv[])
{
    AppDelegate *appDelegate = [[AppDelegate alloc] init];
    [[NSApplication sharedApplication] setDelegate:appDelegate];
    [NSApp run];
    return 0;
}
