//
//  KDAppDelegate.m
//  KatsuDon
//
//  Created by Ayakix on 10/4/12.
//  Copyright (c) 2012 Ayakix. All rights reserved.
//

#import "KDAppDelegate.h"
#import "KDImageUtil.h"
#import "KDPref.h"

@implementation KDAppDelegate

@synthesize window;

- (void)awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    NSBundle *bundle = [NSBundle mainBundle];
    statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"kd_icon" ofType:@"png"]];
    
    [statusItem setImage:statusImage];
    [statusItem setMenu:statusMenu];
    [statusItem setToolTip:@"Katsu-Don"];
    [statusItem setHighlightMode:YES];
}

- (IBAction)openPreferences:(id)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:YES];
    
    NSInteger pressedButton = [openPanel runModal];
    if (pressedButton == NSOKButton) {
        NSString *dirPath = [[openPanel URL] path];
        
        [self registerWatchedDirectory:dirPath];
    } else if ( pressedButton == NSCancelButton ){
//     	NSLog(@"Cancel button was pressed.");
    }
}

- (void)setRootDirPath: (NSString *)rootDirPath {
    NSUserDefaults* userDefaults = [[NSUserDefaultsController sharedUserDefaultsController] values];
    [userDefaults setValue:rootDirPath forKey:ROOT_PATH_KEY];
}

- (NSString *)getRootDirPath {
    NSUserDefaults* userDefaults = [[NSUserDefaultsController sharedUserDefaultsController] values];
    return [userDefaults valueForKey: ROOT_PATH_KEY];
}

- (void)registerWatchedDirectory:(NSString *)path {
    if ([path length] == 0) return;
    
    CFStringRef mypath = (__bridge CFStringRef)path;
    CFArrayRef pathsToWatch = CFArrayCreate(NULL, (const void **)&mypath, 1, NULL);
    
    void *selfPointer = (void*)CFBridgingRetain(self);
    FSEventStreamContext context = {0, selfPointer, NULL, NULL, NULL};
    FSEventStreamRef stream = FSEventStreamCreate(
                                                  NULL,
                                                  &fsevents_callback,
                                                  &context,
                                                  pathsToWatch,
                                                  kFSEventStreamEventIdSinceNow,
                                                  3.0,   // latency
                                                  kFSEventStreamCreateFlagNone
                                                  );
    FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode );
    FSEventStreamStart(stream);
}

void fsevents_callback(
                       ConstFSEventStreamRef streamRef,
                       void *userData,
                       size_t numEvents,
                       void *eventPaths,
                       const FSEventStreamEventFlags eventFlags[],
                       const FSEventStreamEventId eventIds[]) {
    char **paths = eventPaths;
    for(int i = 0; i < numEvents; i++) {
        NSString *path = [NSString stringWithCString: paths[i] encoding:NSUTF8StringEncoding];
        [KDImageUtil transImagesInDictionary: path];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedLongLong:eventIds[numEvents-1]] forKey:@"LAST_EVENT_ID"];
}

@end
