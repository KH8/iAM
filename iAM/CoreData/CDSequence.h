//
//  CDSequence.h
//  iAM
//
//  Created by Krzysztof Reczek on 26.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDStep;

@interface CDSequence : NSManagedObject

@property (nonatomic, retain) NSDate * sequenceCreationDate;
@property (nonatomic, retain) NSString * sequenceName;
@property (nonatomic, retain) NSSet *sequenceSteps;
@end

@interface CDSequence (CoreDataGeneratedAccessors)

- (void)addSequenceStepsObject:(CDStep *)value;
- (void)removeSequenceStepsObject:(CDStep *)value;
- (void)addSequenceSteps:(NSSet *)values;
- (void)removeSequenceSteps:(NSSet *)values;

@end
