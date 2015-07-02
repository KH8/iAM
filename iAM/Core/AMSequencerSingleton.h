//
// Created by Krzysztof Reczek on 20.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMSequencer.h"
#import "AMMutableArray.h"

@interface AMSequencerSingleton : NSObject {
    AMSequencer *sequencer;
    AMMutableArray *arrayOfSequences;
}

@property(nonatomic, retain) AMSequencer *sequencer;
@property(nonatomic, retain) AMMutableArray *arrayOfSequences;

+ (id)sharedSequencer;
@end
