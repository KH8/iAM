//
//  AMStave.m
//  iAM
//
//  Created by Krzysztof Reczek on 08.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMStave.h"
#import "AMNote.h"

@interface AMStave ()

@property NSMutableArray *mainArray;

@property int numberOfLines;
@property int numberOfNotesPerLine;

@end

@implementation AMStave

int defaultNumberOfLines = 5;
int defaultNumberOfNotesPerLine = 11;

- (void)configureDefault{
    [self configureCustomWithNumberOfLines:@(defaultNumberOfLines) numberOfNotesPerLine:@(defaultNumberOfNotesPerLine)];
}

- (void)configureCustomWithNumberOfLines: (NSNumber*)aNumberOfLines numberOfNotesPerLine: (NSNumber*)aNumberOfNotesPerLine{
    _numberOfLines = [aNumberOfLines intValue];
    _numberOfNotesPerLine = [aNumberOfNotesPerLine intValue];

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

- (NSInteger)getLength {
    return defaultNumberOfNotesPerLine;
}


- (NSUInteger)count{
    return _mainArray.count;
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
    [_mainArray insertObject:anObject atIndex:index];
}

- (id)objectAtIndex:(NSUInteger)index{
    return _mainArray[index];
}

@end
