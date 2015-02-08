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

@property NSMutableArray *mainArray;

@property int numberOfLines;
@property int numberOfNotesPerLine;

@property (nonatomic) NSInteger lengthToBePlayed;

@end

@implementation AMBar

NSUInteger const defaultNumberOfLines = 3;
NSUInteger const defaultNumberOfNotesPerLine = 64;

NSUInteger const maxLength = 64;
NSUInteger const minLength = 3;

- (id)init {
    self = [super init];
    if (self) {
        [self initBasicParameters];
    }
    return self;
}

- (void)initBasicParameters {
    _lengthToBePlayed = 16;

    _maxLength = maxLength;
    _minLength = minLength;
}

- (void)configureDefault{
    [self configureCustomWithNumberOfLines:(NSUInteger *) defaultNumberOfLines
                      numberOfNotesPerLine:(NSUInteger *) defaultNumberOfNotesPerLine];
}

- (void)configureCustomWithNumberOfLines: (NSUInteger*)aNumberOfLines
                    numberOfNotesPerLine: (NSUInteger*)aNumberOfNotesPerLine{
    _numberOfLines = (int) aNumberOfLines;
    _numberOfNotesPerLine = (int) aNumberOfNotesPerLine;

    _mainArray = [[NSMutableArray alloc] init];

    for (int i = 0; i < _numberOfLines; i++) {
        NSMutableArray *newLine = [[NSMutableArray alloc] init];
        for (int j = 0; j < _numberOfNotesPerLine; j++) {
            AMNote *newNote = [[AMNote alloc] init];
            newNote.id = @(i * 10 + j);
            [newLine addObject: newNote];
        }
        [_mainArray addObject: newLine];
    }
}

- (void)clear{
    for (NSMutableArray *line in _mainArray) {
        for (AMNote *note in line) {
            if(note.isSelected) {
                [note select];
            }
        }
    }
}

- (void)clearTriggerMarkers{
    for (NSMutableArray *line in _mainArray) {
        for (AMNote *note in line) {
            [note clearTriggerMarker];
        }
    }
}

- (NSInteger)getNumberOfLines {
    return [self count];
}

- (NSUInteger)count{
    return _mainArray.count;
}

- (NSMutableArray *)getLineAtIndex: (NSUInteger)index {
    return [self objectAtIndex:index];
}

- (id)objectAtIndex:(NSUInteger)index{
    return _mainArray[index];
}

- (void)insertObject:(id)anObject
             atIndex:(NSUInteger)index{
    [_mainArray insertObject:anObject
                     atIndex:index];
}

- (void)setLengthToBePlayed:(NSInteger)aLength {
    _lengthToBePlayed = aLength;
}

- (NSInteger)getLengthToBePlayed {
    return _lengthToBePlayed;
}

@end
