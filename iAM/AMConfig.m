//
//  AMConfig.m
//  iAM
//
//  Created by Krzysztof Reczek on 20.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMConfig.h"

static NSString *appName = @"iAM LTD";
static NSString *version = @"v1.0.1";

static int maxBarCount = 16;
static int maxStepCount = 32;
static int maxSequenceCount = 64;
static bool isSoundChangeAllowed = YES;


@implementation AMConfig

+ (NSString *)appName {
    return appName;
}

+ (NSString *)version {
    return version;
}

+ (int)maxBarCount {
    return maxBarCount;
}

+ (int)maxStepCount {
    return maxStepCount;
}

+ (int)maxSequenceCount {
    return maxSequenceCount;
}

+ (bool)isSoundChangeAllowed {
    return isSoundChangeAllowed;
}

+ (bool)shouldAdBeDisplayed {
    return YES;
}

+ (NSString *)barCountExceeded {
    return [NSString stringWithFormat:@"%@\n%@ [ %@ %@ ] %@ %d %@.\n%@",
                                      @"The limit of bar has been reached.",
                                      @"This version of application",
                                      appName,
                                      version,
                                      @"is limited to",
                                      maxBarCount,
                                      @"bars",
                                      @"Consider upgrade to the regular version."];
}

+ (NSString *)stepCountExceeded {
    return [NSString stringWithFormat:@"%@\n%@ [ %@ %@ ] %@ %d %@.\n%@",
                                      @"The limit of steps has been reached.",
                                      @"This version of application",
                                      appName,
                                      version,
                                      @"is limited to",
                                      maxStepCount,
                                      @"steps",
                                      @"Consider upgrade to the regular version."];
}

+ (NSString *)sequenceCountExceeded {
    return [NSString stringWithFormat:@"%@\n%@ [ %@ %@ ] %@ %d %@.\n%@",
                                      @"The limit of sequences has been reached.",
                                      @"This version of application",
                                      appName,
                                      version,
                                      @"is limited to",
                                      maxSequenceCount,
                                      @"sequences",
                                      @"Consider upgrade to the regular version."];
}


+ (NSString *)soundChangeNotAllowed {
    return [NSString stringWithFormat:@"%@\n%@ [ %@ %@ ] %@\n%@",
                                      @"Sound assignment cannot be changed.",
                                      @"This version of application",
                                      appName,
                                      version,
                                      @"is limited.",
                                      @"Consider upgrade to the regular version."];
}

+ (NSString *)appDescription {
    return [NSString stringWithFormat:@"%@ %@\n%@\n[ %@ ]\n\n%@\n",
                                      appName,
                                      version,
                                      @"Advanced Metronome",
                                      @"This version is limited. Consider upgrade to the regular one.",
                                      @"designed and written by: Krzysztof Reczek"];
}

@end
