//
//  Sequence.h
//  iAM
//
//  Created by Krzysztof Reczek on 25.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Step;

@interface Sequence : NSManagedObject

@property (nonatomic, retain) NSDate * sequenceCreationDate;
@property (nonatomic, retain) NSString * sequenceName;
@property (nonatomic, retain) NSSet *sequenceSteps;

@end

@interface Sequence (CoreDataGeneratedAccessors)

- (void)addSequenceStepsObject:(Step *)value;
- (void)removeSequenceStepsObject:(Step *)value;
- (void)addSequenceSteps:(NSSet *)values;
- (void)removeSequenceSteps:(NSSet *)values;

@end
