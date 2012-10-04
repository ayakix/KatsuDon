//
//  KDValidator.m
//  KatsuDon
//
//  Created by Ayakix on 10/4/12.
//  Copyright (c) 2012 Ayakix. All rights reserved.
//

#import "KDValidator.h"

@implementation KDValidator

+ (BOOL) validateDirectoryName:(NSString *)dirName {
    NSString *rDirName = @"(([0-9]*x[0-9]*)|r|bmp|gif|png|jpg|jpeg)+";
    NSRange match = [dirName rangeOfString:rDirName options:NSRegularExpressionSearch];
    if (match.location == NSNotFound) return FALSE;
    
    NSString *matchStr = [dirName substringWithRange:match];
    if (![dirName isEqualToString:matchStr]) return FALSE;
    
    return TRUE;
}

+ (BOOL) validateFileExtension:(NSString *)path {
    NSString *extensionStr = [path pathExtension];
    NSString *rExtension = @"(bmp|gif|png|jpg|jpeg)";
    NSRange match = [extensionStr rangeOfString:rExtension options:NSRegularExpressionSearch];
    if (match.location == NSNotFound) return FALSE;
    
    return TRUE;
}

@end
