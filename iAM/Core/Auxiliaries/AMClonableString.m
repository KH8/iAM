//
//  AMClonableString.m
//  iAM
//
//  Created by Krzysztof Reczek on 23.06.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMClonableString.h"

@interface AMClonableString ()

@property NSString *value;

@end

@implementation AMClonableString

- (id)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        _value = string;
    }
    return self;
}

- (NSString *)getValue {
    return _value;
}

- (id)clone {
    return [[AMClonableString alloc] initWithString:_value];
}

@end
