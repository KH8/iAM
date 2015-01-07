//
//  AMPoint.h
//  iAM
//
//  Created by Krzysztof Reczek on 07.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMPoint : NSObject

@property (weak, nonatomic) NSString *name;

-(void)select;
-(BOOL)isSelected;

@end
