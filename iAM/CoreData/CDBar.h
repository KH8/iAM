//
//  CDBar.h
//  iAM
//
//  Created by Krzysztof Reczek on 26.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDNote, CDStep;

@interface CDBar : NSManagedObject

@property (nonatomic, retain) NSNumber * barDensity;
@property (nonatomic, retain) NSNumber * barSigDenominator;
@property (nonatomic, retain) NSNumber * barSigNumerator;
@property (nonatomic, retain) NSNumber * barTempo;
@property (nonatomic, retain) NSSet *barNotes;
@property (nonatomic, retain) CDStep *step;
@end

@interface CDBar (CoreDataGeneratedAccessors)

- (void)addBarNotesObject:(CDNote *)value;
- (void)removeBarNotesObject:(CDNote *)value;
- (void)addBarNotes:(NSSet *)values;
- (void)removeBarNotes:(NSSet *)values;

@end
