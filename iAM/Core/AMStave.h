//
// Created by Krzysztof Reczek on 05.02.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMBar.h"
#import "AMMutableArray.h"

@protocol AMStaveMechanicalDelegate <NSObject>

@required

- (void)tempoHasBeenChanged;

@end

@interface AMStave : AMMutableArray

@property (nonatomic, weak) id <AMStaveMechanicalDelegate> delegate;

@property (nonatomic) NSInteger maxTempo;
@property (nonatomic) NSInteger minTempo;

- (id)init;
- (id)initWithSubComponents;

- (void)setTempo: (NSInteger)aTempo;
- (NSInteger)getTempo;

- (void)tapTempo;

@end