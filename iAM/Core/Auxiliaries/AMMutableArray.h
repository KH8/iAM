//
//  AMMutableArray.h
//  iAM
//
//  Created by Krzysztof Reczek on 20.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMMutableArrayDelegate <NSObject>

@required

- (void)arrayHasBeenChanged;
- (void)selectionHasBeenChanged;

@end

@interface AMMutableArray : NSObject

@property (nonatomic, weak) id <AMMutableArrayDelegate> delegate;

- (id)init;

- (void)addObject:(NSObject*)newObject;
- (void)addObject:(NSObject*)newObject atIndex:(NSUInteger)anIndex;

- (void)removeActualObject;
- (void)removeObjectAtIndex:(NSUInteger)anIndex;

- (NSInteger)getActualIndex;
- (NSObject*)getActualObject;
- (NSObject*)getObjectAtIndex: (NSUInteger)anIndex;

- (void)setIndexAsActual:(NSUInteger)anIndex;
- (void)setFirstIndexAsActual;
- (void)setNextIndexAsActual;

- (NSUInteger)count;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

@end
