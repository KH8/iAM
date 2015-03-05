//
//  AMSequence.h
//  iAM
//
//  Created by Krzysztof Reczek on 18.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMSequenceStep.h"


@protocol AMSequenceDelegate <NSObject>

@required

- (void)sequenceHasBeenChanged;
- (void)stepHasBeenChanged;

@end

@interface AMSequence : NSObject

@property (nonatomic, weak) id <AMSequenceDelegate> visualDelegate;
@property (nonatomic, weak) id <AMSequenceDelegate> mechanicalDelegate;

- (id)init;

- (AMSequenceStep*)addNewStep;
- (void)removeStep;
- (void)removeStepAtIndex: (NSUInteger)anIndex;

- (NSInteger)getActualIndex;
- (AMSequenceStep*)getNextStep;
- (AMSequenceStep*)getActualStep;
- (AMSequenceStep*)getStepAtIndex: (NSUInteger)anIndex;
- (void)setIndexAsActual:(NSUInteger)anIndex;

- (void)setOneStepForward;
- (void)setOneStepBackward;

- (NSInteger)count;

@end
