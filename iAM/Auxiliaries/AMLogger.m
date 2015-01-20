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
    NSDate *actualDate = [NSDate date];
    NSString *formattedMessage = [NSString stringWithFormat:@"%@: %@", [NSString stringWithUTF8String:[[actualDate description] UTF8String]], aMessage];
    printf("%s\n", [formattedMessage cStringUsingEncoding:[NSString defaultCStringEncoding]]);
}

@end