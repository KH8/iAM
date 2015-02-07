//
// Created by Krzysztof Reczek on 05.02.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMBar.h"

@protocol AMStaveDelegate <NSObject>

@required

- (void) tempoHasBeenChanged;

@end

@interface AMStave : NSObject

@property (nonatomic, weak) id <AMStaveDelegate> delegate;

@property (nonatomic) NSInteger maxTempo;
@property (nonatomic) NSInteger minTempo;

- (id)init;

- (void)setTempo: (NSInteger)aTempo;
- (NSInteger)getTempo;

- (void)addBar;

- (void)setFirstBarAsActual;
- (void)setNextBarAsActual;
- (void)setIndexAsActual: (NSUInteger)index;

- (AMBar*)getActualBar;
- (NSInteger )getActualIndex;

@end