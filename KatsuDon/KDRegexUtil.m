//
//  KDRegexUtil.m
//  KatsuDon
//
//  Created by Ayakix on 10/4/12.
//  Copyright (c) 2012 Ayakix. All rights reserved.
//

#import "KDRegexUtil.h"

@implementation KDRegexUtil

+ (NSBitmapImageFileType) getOutPutFileType: (NSString *)path byCmd:(NSString *)cmd {
    NSLog(@"%@", path);
    NSLog(@"%@", cmd);
    NSArray *extensionArray = [NSArray arrayWithObjects:@"bmp", @"gif", @"png", @"jpg", @"jpeg", nil];
    NSMutableArray *fileTypeArray = [[NSMutableArray alloc] init];
    [fileTypeArray addObject:[NSNumber numberWithInteger:NSBMPFileType]];
    [fileTypeArray addObject:[NSNumber numberWithInteger:NSGIFFileType]];
    [fileTypeArray addObject:[NSNumber numberWithInteger:NSPNGFileType]];
    [fileTypeArray addObject:[NSNumber numberWithInteger:NSJPEGFileType]];
    [fileTypeArray addObject:[NSNumber numberWithInteger:NSJPEGFileType]];
    
    for (NSInteger i = 0; i < [extensionArray count]; i++) {
        NSString *extension = [extensionArray objectAtIndex: i];
        NSRange found = [cmd rangeOfString:extension options:NSLiteralSearch];
        if (found.location == NSNotFound) continue;
        
        return [[fileTypeArray objectAtIndex: i] intValue];
    }
    
    // Return original image extension
    CFStringRef fileExtension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
    if (CFStringCompare(fileUTI, kUTTypeBMP, kCFCompareLocalized) == kCFCompareEqualTo)
        return NSBMPFileType;
    if (CFStringCompare(fileUTI, kUTTypeGIF, kCFCompareLocalized) == kCFCompareEqualTo)
        return NSGIFFileType;
    if (CFStringCompare(fileUTI, kUTTypePNG, kCFCompareLocalized) == kCFCompareEqualTo)
        return NSPNGFileType;
    if (CFStringCompare(fileUTI, kUTTypeJPEG, kCFCompareLocalized) == kCFCompareEqualTo)
        return NSJPEGFileType;
    
    return NSJPEGFileType;
}

+ (NSString *) exceptFileTypeFromCmd: (NSString *)cmd {
    NSMutableString *mCmd = [NSMutableString stringWithString:cmd];
    NSString *rExtension = @"(bmp|gif|png|jpg|jpeg)";
    NSRange match = [mCmd rangeOfString:rExtension options:NSRegularExpressionSearch];
    if (match.location != NSNotFound) {
        [mCmd deleteCharactersInRange:match];
    }
    
    return mCmd;
}

@end
