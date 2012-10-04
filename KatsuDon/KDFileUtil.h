//
//  KDFileUtil.h
//  KatsuDon
//
//  Created by Ayakix on 10/4/12.
//  Copyright (c) 2012 Ayakix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDFileUtil : NSObject

+ (NSString *) getOutputPath: (NSString *)inputPath byFileType:(NSBitmapImageFileType)fileType;
+ (NSString *) getExtensionString: (NSBitmapImageFileType)fileType;
+ (BOOL) saveFile:(NSImage *)image fileType:(NSBitmapImageFileType)outputFileType path:(NSString *)outputPath;
+ (BOOL) deleteFile:(NSString *)path;
+ (NSDictionary *)getProperties:(NSBitmapImageFileType)fileType;

@end
