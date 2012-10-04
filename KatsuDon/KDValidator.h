//
//  KDValidator.h
//  KatsuDon
//
//  Created by Ayakix on 10/4/12.
//  Copyright (c) 2012 Ayakix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDValidator : NSObject

+ (BOOL) validateDirectoryName:(NSString *)dirName;
+ (BOOL) validateFileExtension:(NSString *)path;

@end
