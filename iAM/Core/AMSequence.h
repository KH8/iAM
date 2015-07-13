//
//  AMSequence.h
//  iAM
//
//  Created by Krzysztof Reczek on 18.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMSequenceStep.h"
#import "AMMutableArray.h"

@protocol AMSequenceDelegate <NSObject>

@required

- (void)actualValueHasBeenChanged;

@end

@interface AMSequence : AMMutableArray

@property(nonatomic, weak) id <AMSequenceDelegate> delegate;

- (id)init;

- (id)initWithSubComponents;

- (void)setName:(NSString *)newName;

- (NSString *)getName;

- (void)setCreationDate:(NSDate *)date;

- (NSDate *)getCreationDate;

- (NSString *)getCreationDateString;

- (AMSequenceStep *)getNextStep;

- (void)reset;

- (void)addStep;

- (void)setOneStepForward;

- (void)setOneStepBackward;

- (int)getActualLoopCount;

- (NSTimeInterval)getActualTimeInterval;

@end
