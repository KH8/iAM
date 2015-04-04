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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDSequence"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSInteger i=0; i<fetchedObjects.count; i++) {
        for (CDSequence *sequence in fetchedObjects) {
            if(sequence.sequenceId.integerValue == i){
                [array addObject:[self getSequenceFromCoreData:sequence]];
            }
        }
    }
    
    return array;
}

- (AMSequence*)getSequenceFromCoreData:(CDSequence*)sequence{
    AMSequence *newSequence = [[AMSequence alloc] init];
    [newSequence setName:sequence.sequenceName];
    [newSequence setCreationDate:sequence.sequenceCreationDate];
    for (NSInteger i=0; i<sequence.sequenceSteps.count; i++) {
        for (CDStep *step in sequence.sequenceSteps) {
            if(step.stepId.integerValue == i){
                [newSequence addObject:[self getStepFromCoreData:step]];
            }
        }
    }
    return newSequence;
}

- (AMSequenceStep*)getStepFromCoreData:(CDStep*)step{
    AMSequenceStep *newStep = [[AMSequenceStep alloc] init];
    [newStep setName:step.stepName];
    StepType stepType = [newStep integerToStepType:[step.stepType integerValue]];
    [newStep setStepType:stepType];
    [newStep setNumberOfLoops:[step.stepNumberOfLoops integerValue]];
    AMStave *newStave = [[AMStave alloc] init];
    [newStep setStave:newStave];
    for (NSInteger i=0; i<step.stepBars.count; i++) {
        for (CDBar *bar in step.stepBars) {
            if(bar.barId.integerValue == i){
                [newStave setTempo:[step.stepTempo integerValue]];
                [newStave addObject:[self getBarFromCoreData:bar]];
            }
        }
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
        NSMutableArray *lineOfNotes = [newBar getLineAtIndex:(NSUInteger) [note.noteCoordLine integerValue]];
        AMNote *correspondingNote = lineOfNotes[(NSUInteger) [note.noteCoordPos integerValue]];
        [correspondingNote select];
    }
    return newBar;
}

- (void)getCoreDataFromActualConfiguration:(AMMutableArray*)configuration
                                 inContext:(NSManagedObjectContext*)context{
    for (NSInteger i=0; i<configuration.count; i++) {
        [self getCoreDataFromSequence:configuration[i]
                            withIndex:i
                            inContext:context];
    }
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Core data error occured: %@", [error localizedDescription]);
    }
}

- (void)getCoreDataFromSequence:(AMSequence*)sequence
                      withIndex:(NSInteger)index
                      inContext:(NSManagedObjectContext*)context{
    CDSequence *newSequence = [NSEntityDescription insertNewObjectForEntityForName:@"CDSequence"
                                                            inManagedObjectContext:context];
    newSequence.sequenceId = [[NSNumber alloc] initWithInteger:index];
    newSequence.sequenceName = sequence.getName;
    newSequence.sequenceCreationDate = sequence.getCreationDate;
    for (NSInteger i=0; i<sequence.count; i++) {
        CDStep *newStep = [self getCoreDataFromStep:sequence[i]
                                          withIndex:i
                                          inContext:context];
        newStep.sequence = newSequence;
        [newSequence addSequenceStepsObject:newStep];
    }
}

- (CDStep*)getCoreDataFromStep:(AMSequenceStep*)step
                     withIndex:(NSInteger)index
                     inContext:(NSManagedObjectContext*)context{
    CDStep *newStep = [NSEntityDescription insertNewObjectForEntityForName:@"CDStep"
                                                            inManagedObjectContext:context];
    newStep.stepId = [[NSNumber alloc] initWithInteger:index];
    newStep.stepName = step.getName;
    newStep.stepNumberOfLoops = [[NSNumber alloc] initWithInteger:step.getNumberOfLoops];
    NSInteger stepTypeInteger = [step stepTypeToInteger:[step getStepType]];
    newStep.stepType = [[NSNumber alloc] initWithInteger:stepTypeInteger];
    AMStave *stave = step.getStave;
    newStep.stepTempo = [[NSNumber alloc] initWithInteger:stave.getTempo];
    for (NSInteger i=0; i<stave.count; i++) {
        CDBar *newBar = [self getCoreDataFromBar:stave[i]
                                       withIndex:i
                                       inContext:context];
        newBar.step = newStep;
        [newStep addStepBarsObject:newBar];
    }
    return newStep;
}

- (CDBar*)getCoreDataFromBar:(AMBar*)bar
                   withIndex:(NSInteger)index
                 inContext:(NSManagedObjectContext*)context{
    CDBar *newBar = [NSEntityDescription insertNewObjectForEntityForName:@"CDBar"
                                                  inManagedObjectContext:context];
    newBar.barId = [[NSNumber alloc] initWithInteger:index];
    newBar.barDensity = [[NSNumber alloc] initWithInteger:bar.getDensity];
    newBar.barSigNumerator = [[NSNumber alloc] initWithInteger:bar.getSignatureNumerator];
    newBar.barSigDenominator = [[NSNumber alloc] initWithInteger:bar.getSignatureDenominator];
    NSInteger lineIndex = 0;
    for (NSMutableArray *line in bar) {
        NSInteger noteIndex = 0;
        for (AMNote *note in line) {
            if(note.isSelected){
                CDNote *newNote = [NSEntityDescription insertNewObjectForEntityForName:@"CDNote"
                                                                inManagedObjectContext:context];
                newNote.noteCoordLine = [[NSNumber alloc] initWithInteger:lineIndex];
                newNote.noteCoordPos = [[NSNumber alloc] initWithInteger:noteIndex];
                newNote.bar = newBar;
                [newBar addBarNotesObject:newNote];
            }
            noteIndex++;
        }
        lineIndex++;
    }
    return newBar;
}

@end
