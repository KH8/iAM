//
//  AMDataMapper.h
//  iAM
//
//  Created by Krzysztof Reczek on 27.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMMutableArray.h"
#import "AppDelegate.h"

@interface AMDataMapper : NSObject

- (AMMutableArray*)getActualConfigurationFromContext:(NSManagedObjectContext*)context;
- (void)getCoreDatafromActualConfiguration:(AMMutableArray*)configuration
                                 inContext:(NSManagedObjectContext*)context;

@end
