//
//  AMConfig.m
//  iAM
//
//  Created by Krzysztof Reczek on 20.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMConfig.h"

static NSString *appName = @"tickGrid LTD";
static NSString *version = @"v0.9.0";

static int maxBarCount = 4;
static int maxStepCount = 3;
static int maxSequenceCount = 1;
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

+ (NSString*)barCountExceeded{
    return [NSString stringWithFormat:@"%@\n%@ [ %@ %@ ] %@ %d %@.\n%@",
            @"Maximum number of bars exceeded.",
            @"This version of application",
            appName,
            version,
            @"is limited to",
            maxBarCount,
            @"bars",
            @"Consider upgrade to the regular version."];
}

+ (NSString*)stepCountExceeded{
    return [NSString stringWithFormat:@"%@\n%@ [ %@ %@ ] %@ %d %@.\n%@",
            @"Maximum number of bars exceeded.",
            @"This version of application",
            appName,
            version,
            @"is limited to",
            maxStepCount,
            @"steps",
            @"Consider upgrade to the regular version."];
}

+ (NSString*)sequenceCountExceeded{
    return [NSString stringWithFormat:@"%@\n%@ [ %@ %@ ] %@ %d %@.\n%@",
            @"Maximum number of bars exceeded.",
            @"This version of application",
            appName,
            version,
            @"is limited to",
            maxSequenceCount,
            @"sequence",
            @"Consider upgrade to the regular version."];
}


+ (NSString*)soundChangeNotAllowed{
    return [NSString stringWithFormat:@"%@\n%@ [ %@ %@ ] %@\n%@",
            @"Sound assignment cannot be changed.",
            @"This version of application",
            appName,
            version,
            @"is limited.",
            @"Consider upgrade to the regular version."];
}

@end
