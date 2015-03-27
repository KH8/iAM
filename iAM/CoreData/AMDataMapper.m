//
//  AMDataMapper.m
//  iAM
//
//  Created by Krzysztof Reczek on 27.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMDataMapper.h"
#import "CDStep.h"
#import "CDSequence.h"
#import "CDNote.h"
#import "CDBar.h"

@implementation AMDataMapper

- (AMMutableArray*)getActualConfigurationFromContext:(NSManagedObjectContext*)context{
    AMMutableArray *array = [[AMMutableArray alloc] init];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Core data error occured: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sequence"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (CDSequence *sequence in fetchedObjects) {
        [array addObject:[self getSequenceFromCoreData:sequence]];
    }
    
    return array;
}

- (NSManagedObjectContext*)getContextFromActualConfiguration:(AMMutableArray*)context{
    return nil;
}

- (AMSequence*)getSequenceFromCoreData:(CDSequence*)sequence{
    AMSequence *newSequence = [[AMSequence alloc] init];
    [newSequence setName:sequence.sequenceName];
    [newSequence setCreationDate:sequence.sequenceCreationDate];
    for (CDStep *step in sequence.sequenceSteps) {
        [newSequence addStep:[self getStepFromCoreData:step]];
    }
    return newSequence;
}

- (AMSequenceStep*)getStepFromCoreData:(CDStep*)step{
    return nil;
}

- (void)initCoreDataEntitiesInContext: (NSManagedObjectContext*)context{
    CDSequence *sequence = [NSEntityDescription insertNewObjectForEntityForName:@"Sequence"
                                                         inManagedObjectContext:context];
    sequence.sequenceName = @"NEW SEQUENCE";
    sequence.sequenceCreationDate = [NSDate date];
    
    CDStep *step = [NSEntityDescription insertNewObjectForEntityForName:@"Step"
                                                 inManagedObjectContext:context];
    step.stepName = @"NEW STEP";
    step.stepNumberOfLoops = @0;
    step.stepType = @3;
    step.sequence = sequence;
    [sequence addSequenceStepsObject:step];
    
    CDBar *bar = [NSEntityDescription insertNewObjectForEntityForName:@"Bar"
                                               inManagedObjectContext:context];
    bar.barDensity = @4;
    bar.barTempo = @120;
    bar.barSigNumerator = @4;
    bar.barSigDenominator = @4;
    bar.step = step;
    [step addStepBarsObject:bar];
    
    CDNote *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                                 inManagedObjectContext:context];
    note.noteCoordLine = @1;
    note.noteCoordPos = @1;
    note.bar = bar;
    [bar addBarNotesObject:note];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Core data error occured: %@", [error localizedDescription]);
    }
}

@end
