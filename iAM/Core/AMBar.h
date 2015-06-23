//
//  AMStave.h
//  iAM
//
//  Created by Krzysztof Reczek on 08.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMMutableArray.h"

@protocol AMBarDelegate <NSObject>

@required

- (void)signatureHasBeenChanged;

@end

@interface AMBar : AMMutableArray

- (void)addBarDelegate:(id <AMBarDelegate>)delegate;

- (void)removeBarDelegate:(id <AMBarDelegate>)delegate;

@property(nonatomic) NSInteger maxDensity;
@property(nonatomic) NSInteger minDensity;

@property(nonatomic) NSInteger maxSignature;
@property(nonatomic) NSInteger minSignature;

- (id)init;

- (void)configureDefault;

- (void)configureCustomWithNumberOfLines:(NSUInteger *)aNumberOfLines
                    numberOfNotesPerLine:(NSUInteger *)aNumberOfNotesPerLine;

- (NSInteger)getNumberOfLines;

- (NSMutableArray *)getLineAtIndex:(NSUInteger)index;

- (void)setSignatureNumerator:(NSInteger)aSignatureNumerator;

- (NSInteger)getSignatureNumerator;

- (void)setSignatureDenominator:(NSInteger)aSignatureDenominator;

- (NSInteger)getSignatureDenominator;

- (void)setDensity:(NSInteger)aDensity;

- (NSInteger)getDensity;

- (NSInteger)getLengthToBePlayed;

- (void)clear;

@end