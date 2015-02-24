//
// Created by Krzysztof Reczek on 20.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMAppSingleton.h"

@interface AMAppSingleton()


@end

@implementation AMAppSingleton

+ (id)sharedApplication {
    static AMAppSingleton *sharedApplication = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedApplication = [[self alloc] init];
    });
    return sharedApplication;
}

@end