//
//  AMConfig.m
//  iAM
//
//  Created by Krzysztof Reczek on 20.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMConfig.h"

static NSString *appName = @"tickGrid";
static NSString *version = @"v0.9.0";

static int maxBarCount = 4;
static int maxStepCount = 3;
static int maxSequenceCount = 2;
static bool isSoundChangeAllowed = NO;


@implementation AMConfig

+ (NSString*)appName{
    return appName;
}

+ (NSString*)version{
    return version;
}

+ (int)maxBarCount{
    return maxBarCount;
}

+ (int)maxStepCount{
    return maxStepCount;
}

+ (int)maxSequenceCount{
    return maxSequenceCount;
}

+ (bool)isSoundChangeAllowed{
    return isSoundChangeAllowed;
}

@end
