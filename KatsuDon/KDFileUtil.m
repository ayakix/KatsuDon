//
//  KDFileUtil.m
//  KatsuDon
//
//  Created by Ayakix on 10/4/12.
//  Copyright (c) 2012 Ayakix. All rights reserved.
//

#import "KDFileUtil.h"

@implementation KDFileUtil

+ (NSString *) getOutputPath: (NSString *)inputPath byFileType:(NSBitmapImageFileType)fileType {
    NSMutableString *outputPath = [NSMutableString stringWithString:inputPath];
    
    // Change extension
    [outputPath deleteCharactersInRange:NSMakeRange([outputPath length] - [[outputPath pathExtension] length], [[outputPath pathExtension] length])];
    [outputPath appendString: [self getExtensionString:fileType]];
    
    return outputPath;
}

+ (NSString *) getExtensionString: (NSBitmapImageFileType)fileType {
    if (fileType == NSBMPFileType)  return @"bmp";
    if (fileType == NSGIFFileType)  return @"gif";
    if (fileType == NSPNGFileType)  return @"png";
    if (fileType == NSJPEGFileType) return @"jpg";
    return @"jpg";
}

+ (BOOL) saveFile:(NSImage *)image fileType:(NSBitmapImageFileType)outputFileType path:(NSString *)outputPath {
    NSData           *data;
    NSBitmapImageRep *bitmapImageRep;
    NSDictionary     *properties;
    
    data           = [image TIFFRepresentation];
    bitmapImageRep = [NSBitmapImageRep imageRepWithData:data];
    properties     = [self getProperties:outputFileType];
    data           = [bitmapImageRep representationUsingType:outputFileType properties:properties];
    
    BOOL a = [data writeToFile:outputPath atomically:YES];
    if(a) {
        NSLog(@"success %@", outputPath);
    } else {
        NSLog(@"fail %@", outputPath);
    }
    return a;
    //    return [data writeToFile:outputPath atomically:YES];
}

+ (BOOL) deleteFile:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err;
    return [fileManager removeItemAtPath:path error:&err];
}

+ (NSDictionary *)getProperties:(NSBitmapImageFileType)fileType {
    if (fileType == NSJPEGFileType) {
        return [NSDictionary dictionaryWithObjectsAndKeys :
                [NSNumber numberWithFloat : 1.0 ],
                NSImageCompressionFactor,
                nil];
    }
    if (fileType == NSJPEGFileType) {
        return [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:NSImageInterlaced];
    }
    return nil;
}

@end
