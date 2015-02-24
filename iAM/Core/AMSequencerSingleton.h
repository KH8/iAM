//
// Created by Krzysztof Reczek on 20.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMSequencer.h"

@interface AMSequencerSingleton : NSObject {
    AMSequencer *sequencer;
}

@property (nonatomic, retain) AMSequencer *sequencer;

+ (id)sharedSequencer;

@end
