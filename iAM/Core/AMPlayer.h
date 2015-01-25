//
// Created by Krzysztof Reczek on 13.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AMPlayer : NSObject

- (id)initWithFile: (NSString*)aFileName
            ofType: (NSString*)aFileType;
- (void)playSound;
- (void)stopSound;

@end