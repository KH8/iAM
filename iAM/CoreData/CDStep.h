//
//  CDStep.h
//  iAM
//
//  Created by Krzysztof Reczek on 12.07.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDBar, CDSequence;

@interface CDStep : NSManagedObject

@property (nonatomic, retain) NSNumber * stepId;
@property (nonatomic, retain) NSString * stepName;
@property (nonatomic, retain) NSNumber * stepNumberOfLoops;
@property (nonatomic, retain) NSNumber * stepTempo;
@property (nonatomic, retain) NSNumber * stepTimeDuration;
@property (nonatomic, retain) NSNumber * stepType;
@property (nonatomic, retain) CDSequence *sequence;
@property (nonatomic, retain) NSSet *stepBars;
@end

@interface CDStep (CoreDataGeneratedAccessors)

- (void)addStepBarsObject:(CDBar *)value;
- (void)removeStepBarsObject:(CDBar *)value;
- (void)addStepBars:(NSSet *)values;
- (void)removeStepBars:(NSSet *)values;

@end
