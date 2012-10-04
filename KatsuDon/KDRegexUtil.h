//
//  KDRegexUtil.h
//  KatsuDon
//
//  Created by Ayakix on 10/4/12.
//  Copyright (c) 2012 Ayakix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDRegexUtil : NSObject

+ (NSBitmapImageFileType) getOutPutFileType: (NSString *)path byCmd:(NSString *)cmd;
+ (NSString *) exceptFileTypeFromCmd: (NSString *)cmd;

@end
