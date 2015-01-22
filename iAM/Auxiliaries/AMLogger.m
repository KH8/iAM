//
// Created by Krzysztof Reczek on 20.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMLogger.h"


@implementation AMLogger

+ (id)alloc {
    [NSException raise:@"Cannot be instantiated!" format:@"Static class 'ClassName' cannot be instantiated!"];
    return nil;
}

+ (void)logMessage:(NSString *)aMessage {
    NSLog(@"%@", aMessage);
}

@end