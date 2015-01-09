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

@property NSInteger numberOfLines;
@property NSInteger numberOfNotesPerLine;
@property NSInteger defaultNumberOfLines;
@property NSInteger defaultNumberOfNotesPerLine;

@end

@implementation AMStave

- (void)configureDefault{
    [self configureCustomWithNumberOfLines:[NSNumber numberWithInt:3] numberOfNotesPerLine:[NSNumber numberWithInt:8]];
}

- (void)configureCustomWithNumberOfLines: (NSNumber*)aNumberOfLines numberOfNotesPerLine: (NSNumber*)aNumberOfNotesPerLine{
    self.numberOfLines = [aNumberOfLines intValue];
    self.numberOfNotesPerLine = [aNumberOfNotesPerLine intValue];
    
    self.mainArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.numberOfLines; i++) {
        NSMutableArray *newLine = [[NSMutableArray alloc] init];
        for (int j = 0; j < self.numberOfNotesPerLine; j++) {
            AMNote *newNote = [[AMNote alloc] init];
            newNote.id = [NSNumber numberWithInt:i*10 + j];
            [newLine addObject: newNote];
        }
        [self.mainArray addObject: newLine];
    }
}

- (NSUInteger)count{
    return self.mainArray.count;
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
    [self.mainArray insertObject:anObject atIndex:index];
}

- (id)objectAtIndex:(NSUInteger)index{
    return [self.mainArray objectAtIndex:index];
}

@end
