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
#import "AMNote.h"

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
    AMSequenceStep *newStep = [[AMSequenceStep alloc] init];
    [newStep setName:step.stepName];
    [newStep setStepTypeFromInteger:[step.stepType integerValue]];
    [newStep setNumberOfLoops:[step.stepNumberOfLoops integerValue]];
    AMStave *stave = newStep.getStave;
    for (CDBar *bar in step.stepBars) {
        [stave setTempo:[step.stepTempo integerValue]];
        [stave addBar:[self getBarFromCoreData:bar]];
    }
    return newStep;
}

- (AMBar*)getBarFromCoreData:(CDBar*)bar{
    AMBar *newBar = [[AMBar alloc] init];
    [newBar configureDefault];
    [newBar setSignatureNumerator:[bar.barSigNumerator integerValue]];
    [newBar setSignatureDenominator:[bar.barSigDenominator integerValue]];
    [newBar setDensity:[bar.barDensity integerValue]];
    for (CDNote *note in bar.barNotes) {
        NSMutableArray *lineOfNotes = [newBar getLineAtIndex:[note.noteCoordLine integerValue]];
        AMNote *correspondingNote = lineOfNotes[[note.noteCoordPos integerValue]];
        [correspondingNote select];
    }
    return newBar;
}

- (void)getCoreDatafromActualConfiguration:(AMMutableArray*)configuration
                                 inContext:(NSManagedObjectContext*)context{
    for (AMSequence *sequence in configuration) {
        [self getCoreDataFromSequence:sequence inContext:context];
    }
}

- (void)getCoreDataFromSequence:(AMSequence*)sequence
                             inContext:(NSManagedObjectContext*)context{
    CDSequence *newSequence = [NSEntityDescription insertNewObjectForEntityForName:@"Sequence"
                                                            inManagedObjectContext:context];
    newSequence.sequenceName = sequence.getName;
    newSequence.sequenceCreationDate = sequence.getCreationDate;
    for (AMSequenceStep *step in sequence.getAllSteps) {
        [self getCoreDataFromStep:step];
    }
}

- (void)getCoreDataFromStep:(AMSequenceStep*)step{
    
}

- (void)getCoreDataFromBar:(AMBar*)bar{
    
}

@end
