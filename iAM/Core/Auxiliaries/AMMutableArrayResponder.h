//
// Created by Krzysztof Reczek on 03.04.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMMutableArray.h"


@interface AMMutableArrayResponder : NSObject <AMMutableArrayDelegate>

- (id)initWithArrayHasChangedAction:(SEL)arrayHasChangedSelector
       andSelectionHasChangedAction:(SEL)selectionHasChangedSelector
                          andTarget:(id)target;

@end