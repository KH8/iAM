//
//  AMConfig.h
//  iAM
//
//  Created by Krzysztof Reczek on 20.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMConfig : NSObject

+ (NSString*)appName;
+ (NSString*)version;

+ (int)maxBarCount;
+ (int)maxStepCount;
+ (int)maxSequenceCount;
+ (bool)isSoundChangeAllowed;

+ (NSString*)barCountExceeded;
+ (NSString*)stepCountExceeded;
+ (NSString*)sequenceCountExceeded;
+ (NSString*)soundChangeNotAllowed;
+ (NSString*)appDescription;

@end
