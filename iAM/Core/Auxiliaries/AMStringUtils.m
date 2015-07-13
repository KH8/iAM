//
//  AMStringUtils.m
//  iAM
//
//  Created by Krzysztof Reczek on 13.07.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMStringUtils.h"

@implementation AMStringUtils

+ (NSString *)getTimerDurationString:(NSTimeInterval)interval {
    return [NSString stringWithFormat:@"%02u:%02.0f",
            (int)(interval/60),
            fmod(interval, 60)];
}

@end
