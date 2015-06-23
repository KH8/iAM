//
//  AMMutableArray.h
//  iAM
//
//  Created by Krzysztof Reczek on 20.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMClonableObject.h"

@protocol AMMutableArrayDelegate <NSObject>

@required

- (void)arrayHasBeenChanged;

- (void)selectionHasBeenChanged;

- (void)maxCountExceeded;

@end

@interface AMMutableArray : NSObject

- (id)initWithMaxCount:(int)maxCount;

- (void)addArrayDelegate:(id <AMMutableArrayDelegate>)delegate;

- (void)removeArrayDelegate:(id <AMMutableArrayDelegate>)delegate;

- (void)addObject:(AMClonableObject *)newObject;

- (void)addObject:(AMClonableObject *)newObject atIndex:(NSUInteger)anIndex;

- (void)addObjectAtTheEnd:(AMClonableObject *)newObject;

- (void)removeActualObject;

- (void)removeObjectAtIndex:(NSUInteger)anIndex;

- (void)duplicateObject;

- (NSInteger)getActualIndex;

- (AMClonableObject *)getActualObject;

- (AMClonableObject *)getObjectAtIndex:(NSUInteger)anIndex;

- (void)setIndexAsActual:(NSUInteger)anIndex;

- (void)setFirstIndexAsActual;

- (void)setNextIndexAsActual;

- (void)setPreviousIndexAsActual;

- (NSUInteger)count;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained[])stackbuf count:(NSUInteger)len;

@end
