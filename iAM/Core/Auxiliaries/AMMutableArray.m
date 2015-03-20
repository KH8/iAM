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
@end

@implementation AMMutableArray

- (id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)addObject:(NSObject*)newObject{
    NSUInteger newIndex = 0;
    if(self.count != 0){
        newIndex = _actualIndex + 1;
    }
    [self addObject:newObject atIndex:newIndex];
}

- (void)addObject:(NSObject*)newObject atIndex:(NSUInteger)anIndex{
    [self insertObject:newObject atIndex:anIndex];
    [_delegate arrayHasBeenChanged];
}

- (void)removeActualObject{
    [self removeObjectAtIndex:_actualIndex];
}

- (void)removeObjectAtIndex:(NSUInteger)anIndex{
    if(self.count == 1){
        return;
    }
    [self removeObjectAtIndex:anIndex];
    [_delegate arrayHasBeenChanged];
    if(anIndex == _actualIndex){
        [self setNextIndexAsActual];
    }
}

- (NSInteger)getActualIndex{
    return _actualIndex;
}

- (NSObject*)getActualObject{
    return self[_actualIndex];
}

- (NSObject*)getObjectAtIndex: (NSUInteger)anIndex{
    if(anIndex >= self.count){
        return nil;
    }
    return self[anIndex];
}

- (void)setIndexAsActual:(NSUInteger)anIndex{
    if(anIndex >= self.count){
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
    if(_actualIndex >= self.count) _actualIndex = 0;
    [_delegate selectionHasBeenChanged];
}

@end
