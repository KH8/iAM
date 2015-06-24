//
//  AMMutableArray.m
//  iAM
//
//  Created by Krzysztof Reczek on 20.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMMutableArray.h"

@interface AMMutableArray ()

@property int maxCount;

@property(nonatomic) NSUInteger actualIndex;
@property(nonatomic) NSMutableArray *baseArray;
@property(nonatomic, strong) NSHashTable *arrayDelegates;

@end

@implementation AMMutableArray

- (id)initWithMaxCount:(int)maxCount {
    self = [super init];
    if (self) {
        _maxCount = maxCount;
        _arrayDelegates = [NSHashTable weakObjectsHashTable];
        _baseArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addArrayDelegate:(id <AMMutableArrayDelegate>)delegate {
    [_arrayDelegates addObject:delegate];
}

- (void)removeArrayDelegate:(id <AMMutableArrayDelegate>)delegate {
    [_arrayDelegates removeObject:delegate];
}

- (void)delegateArrayHasBeenChanged {
    for (id <AMMutableArrayDelegate> delegate in _arrayDelegates) {
        [delegate arrayHasBeenChanged];
    }
}

- (void)delegateSelectionHasBeenChanged {
    for (id <AMMutableArrayDelegate> delegate in _arrayDelegates) {
        [delegate selectionHasBeenChanged];
    }
}

- (void)delegateMaxCountExceeded {
    for (id <AMMutableArrayDelegate> delegate in _arrayDelegates) {
        [delegate maxCountExceeded];
    }
}

- (void)addObject:(AMClonableObject *)newObject {
    NSUInteger newIndex = 0;
    if (_baseArray.count != 0) {
        newIndex = _actualIndex + 1;
    }
    [self addObject:newObject atIndex:newIndex];
}

- (void)addObject:(AMClonableObject *)newObject atIndex:(NSUInteger)anIndex {
    if (_baseArray.count == _maxCount) {
        [self delegateMaxCountExceeded];
        return;
    }
    [_baseArray insertObject:newObject atIndex:anIndex];
    [self delegateArrayHasBeenChanged];
}

- (void)addObjectAtTheEnd:(AMClonableObject *)newObject {
    [self addObject:newObject atIndex:_baseArray.count];
}

- (void)removeActualObject {
    [self removeObjectAtIndex:_actualIndex];
}

- (void)removeObjectAtIndex:(NSUInteger)anIndex {
    if (_baseArray.count == 1) {
        return;
    }
    [_baseArray removeObjectAtIndex:anIndex];
    if (anIndex >= _baseArray.count) {
        [self setNextIndexAsActual];
    }
    [self delegateSelectionHasBeenChanged];
    [self delegateArrayHasBeenChanged];
}

- (void)duplicateObject {
    [self addObject:[_baseArray[_actualIndex] clone]
            atIndex:_actualIndex];
    [self delegateArrayHasBeenChanged];
}

- (void)exchangeObjectAtIndex:(NSUInteger)sourceIndex
            withObjectAtIndex:(NSUInteger)targetIndex {
    [_baseArray exchangeObjectAtIndex:sourceIndex
                    withObjectAtIndex:targetIndex];
    [self delegateArrayHasBeenChanged];
}

- (NSInteger)getActualIndex {
    return _actualIndex;
}

- (AMClonableObject *)getActualObject {
    return _baseArray[_actualIndex];
}

- (AMClonableObject *)getObjectAtIndex:(NSUInteger)anIndex {
    if (anIndex >= _baseArray.count) {
        return nil;
    }
    return _baseArray[anIndex];
}

- (void)setIndexAsActual:(NSUInteger)anIndex {
    if (anIndex >= _baseArray.count) {
        return;
    }
    _actualIndex = anIndex;
    [self delegateSelectionHasBeenChanged];
}

- (void)setFirstIndexAsActual {
    _actualIndex = 0;
    [self setIndexAsActual:_actualIndex];
}

- (void)setNextIndexAsActual {
    _actualIndex++;
    if (_actualIndex >= _baseArray.count) _actualIndex = 0;
    [self setIndexAsActual:_actualIndex];
}

- (void)setPreviousIndexAsActual {
    if (_actualIndex == 0) {
        _actualIndex = _baseArray.count - 1;
    }
    else {
        _actualIndex--;
    }
    [self setIndexAsActual:_actualIndex];
}

- (NSUInteger)count {
    return [_baseArray count];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return _baseArray[idx];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    _baseArray[idx] = obj;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained[])stackbuf count:(NSUInteger)len {
    return [_baseArray countByEnumeratingWithState:state objects:stackbuf count:len];
}

- (void)setBaseArray:(NSMutableArray *)array {
    _baseArray = array;
}

- (id)clone {
    AMMutableArray *clone = [[AMMutableArray alloc] initWithMaxCount:_maxCount];
    for (AMClonableObject *object in _baseArray) {
        [clone addObjectAtTheEnd:[object clone]];
    }
    [clone setActualIndex:_actualIndex];
    return clone;
}

@end
