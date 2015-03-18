//
// Created by Krzysztof Reczek on 20.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMSequencer.h"

@interface AMSequencerSingleton : NSObject {
    AMSequencer *sequencer;
    NSMutableArray *arrayOfSequences;
}

@property (nonatomic, retain) AMSequencer *sequencer;
@property (nonatomic, retain) NSMutableArray *arrayOfSequences;

+ (id)sharedSequencer;


@end
