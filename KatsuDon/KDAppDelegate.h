//
//  KDAppDelegate.h
//  KatsuDon
//
//  Created by Ayakix on 10/4/12.
//  Copyright (c) 2012 Ayakix. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KDAppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusHighLightImage;
}

- (IBAction)openPreferences:(id)sender;
- (void)setRootDirPath: (NSString *)rootDirPath;
- (NSString *)getRootDirPath;
- (void)registerWatchedDirectory:(NSString *)path;

@property (assign) IBOutlet NSWindow *window;

@end
