//
//  KDImageUtil.h
//  KatsuDon
//
//  Created by Ayakix on 10/4/12.
//  Copyright (c) 2012 Ayakix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDImageUtil : NSObject

+ (void) transImagesInDictionary:(NSString *)dirPath;
+ (NSImage *) transImage: (NSImage *)image byCmd:(NSString *)cmd;
+ (NSSize) getSizeFromCmd: (NSString *)cmd;
+ (NSImage *)resizeImage:(NSImage *)sourceImage bySize:(NSSize)size;
+ (NSImage *)rotateImage: (NSImage *)sourceImage byAngle:(int)degrees;

@end
