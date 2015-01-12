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

int defaultNumberOfLines = 3;
int defaultNumberOfNotesPerLine = 8;

- (void)configureDefault{
    [self configureCustomWithNumberOfLines:@(defaultNumberOfLines) numberOfNotesPerLine:@(defaultNumberOfNotesPerLine)];
}

- (void)configureCustomWithNumberOfLines: (NSNumber*)aNumberOfLines numberOfNotesPerLine: (NSNumber*)aNumberOfNotesPerLine{
    self.numberOfLines = [aNumberOfLines intValue];
    self.numberOfNotesPerLine = [aNumberOfNotesPerLine intValue];
    
    self.mainArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.numberOfLines; i++) {
        NSMutableArray *newLine = [[NSMutableArray alloc] init];
        for (int j = 0; j < self.numberOfNotesPerLine; j++) {
            AMNote *newNote = [[AMNote alloc] init];
            newNote.id = @(i * 10 + j);
            [newLine addObject: newNote];
        }
        [self.mainArray addObject: newLine];
    }
}

- (void)clear{
    for (NSMutableArray *line in self.mainArray) {
        for (AMNote *note in line) {
            if(note.isSelected) {
                [note select];
            }
        }
    }
}

- (NSUInteger)count{
    return self.mainArray.count;
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
    [self.mainArray insertObject:anObject atIndex:index];
}

- (id)objectAtIndex:(NSUInteger)index{
    return self.mainArray[index];
}

@end
