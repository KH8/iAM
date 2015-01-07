//
//  AMPoint.m
//  iAM
//
//  Created by Krzysztof Reczek on 07.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMPoint.h"

@interface AMPoint ()

@property (atomic) BOOL selectionState;

@end

@implementation AMPoint

-(void)select{
    self.selectionState = !self.selectionState;
}

-(BOOL)isSelected{
    return self.selectionState;
}

@end
