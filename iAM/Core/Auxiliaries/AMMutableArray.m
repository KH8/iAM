//
//  AMMutableArray.m
//  iAM
//
//  Created by Krzysztof Reczek on 20.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMMutableArray.h"

@interface AMMutableArray ()

@property (nonatomic) NSUInteger actualIndex;
@property NSMutableArray *baseArray;

@end

@implementation AMMutableArray

- (id)init{
    self = [super init];
    if (self) {
        _baseArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addObject:(NSObject*)newObject{
    NSUInteger newIndex = 0;
    if(_baseArray.count != 0){
        newIndex = _actualIndex + 1;
    }
    [self addObject:newObject atIndex:newIndex];
}

- (void)addObject:(NSObject*)newObject atIndex:(NSUInteger)anIndex{
    [_baseArray insertObject:newObject atIndex:anIndex];
    [_delegate arrayHasBeenChanged];
}

- (void)removeActualObject{
    [self removeObjectAtIndex:_actualIndex];
}

- (void)removeObjectAtIndex:(NSUInteger)anIndex{
    if(_baseArray.count == 1){
        return;
    }
    [_baseArray removeObjectAtIndex:anIndex];
    [_delegate arrayHasBeenChanged];
    if(anIndex == _actualIndex){
        [self setNextIndexAsActual];
    }
}

- (NSInteger)getActualIndex{
    return _actualIndex;
}

- (NSObject*)getActualObject{
    return _baseArray[_actualIndex];
}

- (NSObject*)getObjectAtIndex: (NSUInteger)anIndex{
    if(anIndex >= _baseArray.count){
        return nil;
    }
    return _baseArray[anIndex];
}

- (void)setIndexAsActual:(NSUInteger)anIndex{
    if(anIndex >= _baseArray.count){
        return;
    }
    _actualIndex = anIndex;
}

- (void)setFirstIndexAsActual{
    _actualIndex = 0;
    [_delegate selectionHasBeenChanged];
}

- (void)setNextIndexAsActual{
    _actualIndex++;
    if(_actualIndex >= _baseArray.count) _actualIndex = 0;
    [_delegate selectionHasBeenChanged];
}

- (NSUInteger)count{
    return [_baseArray count];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx{
    return _baseArray[idx];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx{
    _baseArray[idx] = obj;
}


@end
