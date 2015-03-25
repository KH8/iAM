//
//  Bar.h
//  iAM
//
//  Created by Krzysztof Reczek on 25.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note, Step;

@interface Bar : NSManagedObject

@property (nonatomic, retain) NSNumber * barDensity;
@property (nonatomic, retain) NSNumber * barId;
@property (nonatomic, retain) NSNumber * barSigDenominator;
@property (nonatomic, retain) NSNumber * barSigNumerator;
@property (nonatomic, retain) NSNumber * barStepId;
@property (nonatomic, retain) NSNumber * barTempo;
@property (nonatomic, retain) NSSet *barNotes;
@property (nonatomic, retain) Step *step;

@end

@interface Bar (CoreDataGeneratedAccessors)

- (void)addBarNotesObject:(Note *)value;
- (void)removeBarNotesObject:(Note *)value;
- (void)addBarNotes:(NSSet *)values;
- (void)removeBarNotes:(NSSet *)values;

@end
