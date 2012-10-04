//
//  KDImageUtil.m
//  KatsuDon
//
//  Created by Ayakix on 10/4/12.
//  Copyright (c) 2012 Ayakix. All rights reserved.
//

#import "KDImageUtil.h"
#import "KDRegexUtil.h"
#import "KDFileUtil.h"
#import "KDValidator.h"

@implementation KDImageUtil

NSMutableArray *transformedImageArray;

+ (void) transImagesInDictionary:(NSString *)dirPath {
    if (transformedImageArray == nil) {
        transformedImageArray = [[NSMutableArray alloc] init];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator;
    
    enumerator = [fileManager enumeratorAtPath:dirPath];
    NSString *path;
    
    while (path = [enumerator nextObject])
    {
        path = [dirPath stringByAppendingPathComponent:path];
        
        NSString *dirName = [dirPath lastPathComponent];
        if (![KDValidator validateDirectoryName:dirName]) continue;
        if (![KDValidator validateFileExtension:path])    continue;
        if ([transformedImageArray containsObject:path])  continue;
        
        NSBitmapImageFileType outputFileType = [KDRegexUtil getOutPutFileType:path byCmd:dirName];
        dirName = [KDRegexUtil exceptFileTypeFromCmd:dirName];
        
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
        image = [KDImageUtil transImage:image byCmd:dirName];
        
        NSString *outputPath = [KDFileUtil getOutputPath:path byFileType:outputFileType];
        
        [KDFileUtil saveFile:image fileType:outputFileType path:outputPath];
        if (![outputPath isEqualToString:path])
            [KDFileUtil deleteFile:path];
        
        [transformedImageArray addObject:outputPath];
    }
}

+ (NSImage *) transImage: (NSImage *)image byCmd:(NSString *)cmd {
    NSMutableString *mCmd = [NSMutableString stringWithString:cmd];
    
    NSRange match;
    BOOL transFg = TRUE;
    while (transFg) {
        // resize
        match = [mCmd rangeOfString:@"[0-9]*x[0-9]*" options:NSRegularExpressionSearch];
        if (match.location != NSNotFound && match.location == 0) {
            NSString *widthXHeight = [mCmd substringWithRange:match]; // extract (200x400 | x400 | 200x)
            NSSize size = [self getSizeFromCmd:widthXHeight];
            image = [self resizeImage:image bySize:size];
            [mCmd deleteCharactersInRange:match];
            continue;
        }
        
        // rotate
        match = [mCmd rangeOfString:@"r+" options:NSRegularExpressionSearch];
        if (match.location != NSNotFound && match.location == 0) {
            int rotateCnt = (int)[[mCmd substringWithRange:match] length];
            image = [self rotateImage:image byAngle:(90 * rotateCnt)];
            [mCmd deleteCharactersInRange:match];
            continue;
        }
        
        transFg = FALSE;
    }
    return image;
}

+ (NSSize) getSizeFromCmd: (NSString *)cmd {
    NSRange  xRange     = [cmd rangeOfString:@"x"];
    NSString *widthStr  = [cmd substringToIndex:xRange.location];
    NSString *heightStr = [cmd substringFromIndex:xRange.location + xRange.length];
    
    float width  = ([widthStr length] > 0)  ? [widthStr floatValue]  : 0;
    float height = ([heightStr length] > 0) ? [heightStr floatValue] : 0;
    
    return NSMakeSize(width, height);
}

+ (NSImage *)resizeImage:(NSImage *)sourceImage bySize:(NSSize)size {
    NSSize originalSize = [sourceImage size];
    size.width  = (size.width > 0) ? size.width : (size.height / originalSize.height) *originalSize.width;
    size.height = (size.height > 0) ? size.height : (size.width / originalSize.width) * originalSize.height;
    NSImage *newImage   = [[NSImage alloc] initWithSize: NSMakeSize(size.width, size.height)];
    
    [newImage lockFocus];
    [sourceImage drawInRect: NSMakeRect(0, 0, size.width, size.height)
                   fromRect: NSMakeRect(0, 0, originalSize.width, originalSize.height)
                  operation: NSCompositeSourceOver fraction: 1.0];
    [newImage unlockFocus];
    
    return newImage;
}


+ (NSImage *)rotateImage: (NSImage *)sourceImage byAngle:(int)degrees {
    NSSize beforeSize = [sourceImage size];
    NSSize afterSize = degrees == 90 || degrees == -90 ? NSMakeSize(beforeSize.height, beforeSize.width) : beforeSize;
    NSImage* newImage = [[NSImage alloc] initWithSize:afterSize];
    NSAffineTransform* trans = [NSAffineTransform transform];
    
    [newImage lockFocus];
    [trans translateXBy:afterSize.width * 0.5 yBy:afterSize.height * 0.5];
    [trans rotateByDegrees:-degrees];
    [trans translateXBy:-beforeSize.width * 0.5 yBy:-beforeSize.height * 0.5];
    [trans set];
    [sourceImage drawAtPoint:NSZeroPoint
                    fromRect:NSMakeRect(0, 0, beforeSize.width, beforeSize.height)
                   operation:NSCompositeCopy
                    fraction:1.0];
    [newImage unlockFocus];
    return newImage;
}

@end
