//
//  AMDataMapper.h
//  iAM
//
//  Created by Krzysztof Reczek on 27.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AMSequencer.h"

@interface AMDataMapper : NSObject

- (void)getConfigurationOfSequencer:(AMSequencer*)sequencer
                        fronContext:(NSManagedObjectContext*)context;
- (AMMutableArray*)getActualConfigurationFromContext:(NSManagedObjectContext*)context;

- (void)getCoreDataConfigurationOfSequencer:(AMSequencer*)sequencer
                                  inContext:(NSManagedObjectContext*)context;
- (void)getCoreDataFromActualConfiguration:(AMMutableArray*)configuration
                                 inContext:(NSManagedObjectContext*)context;
    
@end
