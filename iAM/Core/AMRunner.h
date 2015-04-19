//
//  AMRunner.h
//  iAM
//
//  Created by Krzysztof Reczek on 19.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMRunner : NSObject

- (id)initWithTickAction:(SEL)selector andTarget:(id)target;
- (void)changeIntervalTime:(NSNumber*)intervalTime;

@end
