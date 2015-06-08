//
//  AMCommonConfiguration.m
//  iAM
//
//  Created by Krzysztof Reczek on 08.06.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMApplicationDelegate.h"

@implementation AMApplicationDelegate

+ (AppDelegate *)getAppDelegate {
    return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

@end
