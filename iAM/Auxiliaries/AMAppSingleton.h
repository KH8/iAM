//
// Created by Krzysztof Reczek on 20.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMSequence.h"

@interface AMAppSingleton : NSObject{
    AMSequence *mainSequencer;
}

@property (nonatomic, retain) NSString *mainSequencer;

+ (id)sharedApplication;

@end