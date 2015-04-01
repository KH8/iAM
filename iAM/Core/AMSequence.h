//
//  AMSequence.h
//  iAM
//
//  Created by Krzysztof Reczek on 18.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMSequenceStep.h"
#import "AMMutableArray.h"

@interface AMSequence : AMMutableArray

- (id)init;
- (id)initWithSubComponents;

- (void)setName:(NSString*)newName;
- (NSString*)getName;

- (void)setCreationDate:(NSDate*)date;
- (NSDate*)getCreationDate;
- (NSString*)getCreationDateString;

@end
