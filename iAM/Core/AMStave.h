//
// Created by Krzysztof Reczek on 05.02.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMBar.h"

@protocol AMStaveMechanicalDelegate <NSObject>

@required

- (void)tempoHasBeenChanged;
- (void)barHasBeenChanged;

@end

@protocol AMStaveVisualDelegate <NSObject>

@required

- (void)barHasBeenChanged;

@end

@interface AMStave : NSObject <AMBarVisualDelegate>

@property (nonatomic, weak) id <AMStaveMechanicalDelegate> mechanicalDelegate;
@property (nonatomic, weak) id <AMStaveMechanicalDelegate> mechanicalPickerViewDelegate;
@property (nonatomic, weak) id <AMStaveVisualDelegate> visualDelegate;
@property (nonatomic, weak) id <AMStaveVisualDelegate> visualPageViewDelegate;

@property (nonatomic) NSInteger maxTempo;
@property (nonatomic) NSInteger minTempo;

- (id)init;

- (void)setTempo: (NSInteger)aTempo;
- (NSInteger)getTempo;
- (void)tapTempo;

- (void)addBar;
- (void)addBar:(AMBar*)newBar;
- (void)removeActualBar;

- (void)setFirstBarAsActual;
- (void)setNextBarAsActual;
- (void)setIndexAsActual: (NSUInteger)index;

- (AMBar*)getActualBar;
- (NSInteger)getActualIndex;
- (NSInteger)getSize;

- (void)clearAllTriggerMarkers;

@end