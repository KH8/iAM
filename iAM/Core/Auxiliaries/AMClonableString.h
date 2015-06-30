//
//  AMClonableString.h
//  iAM
//
//  Created by Krzysztof Reczek on 23.06.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMClonableObject.h"

@interface AMClonableString : AMClonableObject

- (id)initWithString:(NSString *)string;

- (NSString *)getValue;

@end
