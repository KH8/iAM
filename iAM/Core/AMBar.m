//
//  AMStave.m
//  iAM
//
//  Created by Krzysztof Reczek on 08.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMBar.h"
#import "AMNote.h"

@interface AMBar ()

@property int numberOfLines;
@property int numberOfNotesPerLine;

@property(nonatomic) NSInteger signatureNumerator;
@property(nonatomic) NSInteger signatureDenominator;
@property(nonatomic) NSInteger density;

@property(nonatomic, strong) NSHashTable *barDelegates;

@end

@implementation AMBar

NSUInteger const defaultNumberOfLines = 3;
NSUInteger const defaultNumberOfNotesPerLine = 128;

NSUInteger const maxDensity = 1;
NSUInteger const minDensity = 4;

NSUInteger const maxSignature = 16;
NSUInteger const minSignature = 1;

- (void)addBarDelegate:(id <AMBarDelegate>)delegate {
    [_barDelegates addObject:delegate];
}

- (void)removeBarDelegate:(id <AMBarDelegate>)delegate {
    [_barDelegates removeObject:delegate];
}

- (void)delegateSignatureHasBeenChanged {
    for (id <AMBarDelegate> delegate in _barDelegates) {
        [delegate signatureHasBeenChanged];
    }
}

- (id)init {
    self = [super initWithMaxCount:defaultNumberOfLines];
    if (self) {
        _barDelegates = [NSHashTable weakObjectsHashTable];
        [self initBasicParameters];
    }
    return self;
}

- (void)initBasicParameters {
    _density = 4;

    _signatureNumerator = 4;
    _signatureDenominator = 4;

    _maxDensity = maxDensity;
    _minDensity = minDensity;

    _maxSignature = maxSignature;
    _minSignature = minSignature;
}

- (void)configureDefault {
    [self configureCustomWithNumberOfLines:(NSUInteger *) defaultNumberOfLines
                      numberOfNotesPerLine:(NSUInteger *) defaultNumberOfNotesPerLine];
}

- (void)configureCustomWithNumberOfLines:(NSUInteger *)aNumberOfLines
                    numberOfNotesPerLine:(NSUInteger *)aNumberOfNotesPerLine {
    _numberOfLines = (int) aNumberOfLines;
    _numberOfNotesPerLine = (int) aNumberOfNotesPerLine;

    for (int i = 0; i < _numberOfLines; i++) {
        AMMutableArray *newLine = [[AMMutableArray alloc] initWithMaxCount:_numberOfNotesPerLine];
        for (int j = 0; j < _numberOfNotesPerLine; j++) {
            AMNote *newNote = [[AMNote alloc] init];
            newNote.id = @(i * 10 + j);
            [newLine addObject:newNote];
        }
        [self addObject:newLine];
    }
    [self updateMajorNotes];
}

- (void)updateMajorNotes {
    for (AMMutableArray *line in self) {
        int i = 0;
        for (AMNote *note in line) {
            [note markMajorNoteState:NO];
            if (i % 4 == 0) {
                [note markMajorNoteState:YES];
            }
            i++;
        }
    }
}

- (NSInteger)getNumberOfLines {
    return [self count];
}

- (void)setSignatureNumerator:(NSInteger)aSignatureNumerator {
    _signatureNumerator = aSignatureNumerator;
    [self delegateSignatureHasBeenChanged];
}

- (NSInteger)getSignatureNumerator {
    return _signatureNumerator;
}

- (void)setSignatureDenominator:(NSInteger)aSignatureDenominator {
    _signatureDenominator = aSignatureDenominator;
    [self delegateSignatureHasBeenChanged];
}

- (NSInteger)getSignatureDenominator {
    return _signatureDenominator;
}

- (void)setDensity:(NSInteger)aDensity {
    _density = aDensity;
    [self updateMajorNotes];
    [self delegateSignatureHasBeenChanged];
}

- (NSInteger)getDensity {
    return _density;
}

- (NSInteger)getLengthToBePlayed {
    return _density * _signatureNumerator;
}

- (void)clear {
    for (AMMutableArray *line in self) {
        for (AMNote *note in line) {
            if (note.isSelected) {
                [note select];
            }
        }
    }
}

- (id)clone {
    AMBar *clone = [[AMBar alloc] init];
    [clone setBaseArray:[[super clone] getBaseArray]];
    [clone setSignatureNumerator:_signatureNumerator];
    [clone setSignatureDenominator:_signatureDenominator];
    [clone setDensity:_density];
    return clone;
}

@end
