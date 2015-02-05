//
//  AMStave.h
//  iAM
//
//  Created by Krzysztof Reczek on 08.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMBar : NSMutableArray

@property (nonatomic) NSInteger maxLength;
@property (nonatomic) NSInteger minLength;

- (id)init;

- (void)configureDefault;
- (void)configureCustomWithNumberOfLines: (NSUInteger*)aNumberOfLines
                    numberOfNotesPerLine: (NSUInteger*)aNumberOfNotesPerLine;

- (NSInteger)getNumberOfLines;
- (NSMutableArray *)getLineAtIndex: (NSUInteger)index;
- (void)setLengthToBePlayed: (NSInteger)aLength;
- (NSInteger)getLengthToBePlayed;

- (void)clear;

@end
