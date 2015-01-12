//
//  AMStave.h
//  iAM
//
//  Created by Krzysztof Reczek on 08.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMStave : NSMutableArray

- (void)configureDefault;
- (void)configureCustomWithNumberOfLines: (NSNumber*)aNumberOfLines numberOfNotesPerLine: (NSNumber*)aNumberOfNotesPerLine;

- (void)clear;

- (NSInteger)getLength;

@end
