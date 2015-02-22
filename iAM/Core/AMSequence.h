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
- (void)selectionHasBeenChanged;

@end

@interface AMSequence : NSObject

@property (nonatomic, weak) id <AMSequenceDelegate> delegate;

- (id)init;

- (void)addNewStep;
- (void)removeStep;
- (void)removeStepAtIndex: (NSUInteger)anIndex;

- (NSInteger)getActualIndex;
- (AMSequenceStep*)getNextStep;
- (AMSequenceStep*)getStepAtIndex: (NSUInteger)anIndex;
- (void)setIndexAsActual:(NSUInteger)anIndex;

- (NSInteger)count;

@end
