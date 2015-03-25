//
//  Step.h
//  iAM
//
//  Created by Krzysztof Reczek on 25.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bar, Sequence;

@interface Step : NSManagedObject

@property (nonatomic, retain) NSString * stepName;
@property (nonatomic, retain) NSNumber * stepNumberOfLoops;
@property (nonatomic, retain) NSNumber * stepType;
@property (nonatomic, retain) Sequence *sequence;
@property (nonatomic, retain) NSSet *stepBars;

@end

@interface Step (CoreDataGeneratedAccessors)

- (void)addStepBarsObject:(Bar *)value;
- (void)removeStepBarsObject:(Bar *)value;
- (void)addStepBars:(NSSet *)values;
- (void)removeStepBars:(NSSet *)values;

@end
