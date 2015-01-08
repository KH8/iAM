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

@property NSInteger defaultNumberOfLines;
@property NSInteger defaultNumberOfNotesPerLine;

@end

@implementation AMStave

- (void)configureDefault{
    [self configureCustomWithNumberOfLines:[NSNumber numberWithInt:3] numberOfNotesPerLine:[NSNumber numberWithInt:8]];
}

- (void)configureCustomWithNumberOfLines: (NSNumber*)aNumberOfLines numberOfNotesPerLine: (NSNumber*)aNumberOfNotesPerLine{
    int numberOfLines = [aNumberOfLines intValue];
    int numberOfNotesPerLine = [aNumberOfNotesPerLine intValue];
    
    for (int i; i < numberOfLines; i++) {
        NSMutableArray *newLine = [[NSMutableArray alloc] init];
        for (int j; j < numberOfNotesPerLine; j++) {
            AMNote *newNote = [[AMNote alloc] init];
            [newLine addObject: newNote];
        }
        [self addObject: newLine];
    }
}

@end
