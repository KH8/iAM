//
// Created by Krzysztof Reczek on 05.02.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMBar.h"
#import "AMMutableArray.h"

@protocol AMStaveDelegate <NSObject>

@required

- (void)tempoHasBeenChanged;

- (void)tempoHasBeenTapped;

@end

@interface AMStave : AMMutableArray

- (void)addStaveDelegate:(id <AMStaveDelegate>)delegate;

- (void)removeStaveDelegate:(id <AMStaveDelegate>)delegate;

@property(nonatomic) NSInteger maxTempo;
@property(nonatomic) NSInteger minTempo;

- (id)init;

- (id)initWithSubComponents;

- (void)setTempo:(NSInteger)aTempo;

- (NSInteger)getTempo;

- (void)tapTempo;

- (void)addBar;

@end