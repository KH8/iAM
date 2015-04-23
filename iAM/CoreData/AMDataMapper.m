//
//  AMDataMapper.m
//  iAM
//
//  Created by Krzysztof Reczek on 27.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMDataMapper.h"
#import "AMNote.h"
#import "AMPlayer.h"
#import "AMConfig.h"
#import "CDStep.h"
#import "CDSequence.h"
#import "CDNote.h"
#import "CDBar.h"
#import "CDSelections.h"
#import "CDConfiguration.h"

@implementation AMDataMapper

- (void)getConfigurationOfSequencer:(AMSequencer*)sequencer
                        fromContext:(NSManagedObjectContext*)context{
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Core data error occured: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDConfiguration"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    CDConfiguration *configuration = fetchedObjects[0];
    
    NSArray *players = [sequencer getArrayOfPlayers];
    
    AMPlayer *playerTrack1 = (AMPlayer*)players[0];
    [playerTrack1 setSoundName:configuration.soundTrack1Value
                       withKey:configuration.soundTrack1Key];
    [playerTrack1 setVolumeFactor:configuration.volumeTrack1];
    [playerTrack1 setGeneralVolumeFactor:configuration.volumeGeneral];
    
    AMPlayer *playerTrack2 = (AMPlayer*)players[1];
    [playerTrack2 setSoundName:configuration.soundTrack2Value
                       withKey:configuration.soundTrack2Key];
    [playerTrack2 setVolumeFactor:configuration.volumeTrack2];
    [playerTrack2 setGeneralVolumeFactor:configuration.volumeGeneral];
    
    AMPlayer *playerTrack3 = (AMPlayer*)players[2];
    [playerTrack3 setSoundName:configuration.soundTrack3Value
                       withKey:configuration.soundTrack3Key];
    [playerTrack3 setVolumeFactor:configuration.volumeTrack3];
    [playerTrack3 setGeneralVolumeFactor:configuration.volumeGeneral];
}

- (AMMutableArray*)getActualConfigurationFromContext:(NSManagedObjectContext*)context{
    AMMutableArray *array = [[AMMutableArray alloc] initWithMaxCount:[AMConfig maxSequenceCount]];
    
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
                [array addObjectAtTheEnd:[self getSequenceFromCoreData:sequence]];
                break;
            }
        }
    }
    
    [self getActualSelectionsFromContext:context
                andInjectToConfiguration:array];
    
    return array;
}

- (void)getActualSelectionsFromContext:(NSManagedObjectContext*)context
              andInjectToConfiguration:(AMMutableArray*)configuration{
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Core data error occured: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDSelections"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    CDSelections *selections = fetchedObjects[0];

    [configuration setIndexAsActual:(NSUInteger) selections.sequenceSelected.integerValue];
    
    AMSequence *selectedSequence = (AMSequence *)configuration.getActualObject;
    [selectedSequence setIndexAsActual:(NSUInteger) selections.stepSelected.integerValue];
    
    AMSequenceStep *selectedStep = (AMSequenceStep *)selectedSequence.getActualObject;
    AMStave *selectedStave = selectedStep.getStave;
    [selectedStave setIndexAsActual:0];
}

- (AMSequence*)getSequenceFromCoreData:(CDSequence*)sequence{
    AMSequence *newSequence = [[AMSequence alloc] init];
    [newSequence setName:sequence.sequenceName];
    [newSequence setCreationDate:sequence.sequenceCreationDate];
    for (NSInteger i=0; i<sequence.sequenceSteps.count; i++) {
        for (CDStep *step in sequence.sequenceSteps) {
            if(step.stepId.integerValue == i){
                [newSequence addObjectAtTheEnd:[self getStepFromCoreData:step]];
                break;
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
    [newStave setTempo:[step.stepTempo integerValue]];
    for (NSInteger i=0; i<step.stepBars.count; i++) {
        for (CDBar *bar in step.stepBars) {
            if(bar.barId.integerValue == i){
                [newStave addObjectAtTheEnd:[self getBarFromCoreData:bar]];
                break;
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
        [self getCoreDataFromSequence:configuration[(NSUInteger) i]
                            withIndex:i
                            inContext:context];
    }
    
    [self getCoreDataFromActualSelections:configuration
                                inContext:context];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Core data error occured: %@", [error localizedDescription]);
    }
}

- (void)getCoreDataConfigurationOfSequencer:(AMSequencer*)sequencer
                                  inContext:(NSManagedObjectContext*)context{
    CDConfiguration *selections = [NSEntityDescription insertNewObjectForEntityForName:@"CDConfiguration"
                                                             inManagedObjectContext:context];
    NSArray *players = [sequencer getArrayOfPlayers];
    
    AMPlayer *playerTrack1 = (AMPlayer*)players[0];
    selections.soundTrack1Key = [playerTrack1 getSoundKey];
    selections.soundTrack1Value = [playerTrack1 getSoundName];
    selections.volumeTrack1 = [playerTrack1 getVolumeFactor];
    
    AMPlayer *playerTrack2 = (AMPlayer*)players[1];
    selections.soundTrack2Key = [playerTrack2 getSoundKey];
    selections.soundTrack2Value = [playerTrack2 getSoundName];
    selections.volumeTrack2 = [playerTrack2 getVolumeFactor];
    
    AMPlayer *playerTrack3 = (AMPlayer*)players[2];
    selections.soundTrack3Key = [playerTrack3 getSoundKey];
    selections.soundTrack3Value = [playerTrack3 getSoundName];
    selections.volumeTrack3 = [playerTrack3 getVolumeFactor];
    
    selections.volumeGeneral = [playerTrack3 getGeneralVolumeFactor];
}

- (void)getCoreDataFromActualSelections:(AMMutableArray*)configuration
                              inContext:(NSManagedObjectContext*)context{
    CDSelections *selections = [NSEntityDescription insertNewObjectForEntityForName:@"CDSelections"
                                                             inManagedObjectContext:context];
    selections.sequenceSelected = [[NSNumber alloc] initWithInteger:configuration.getActualIndex];
    
    AMSequence *selectedSequence = (AMSequence *)configuration.getActualObject;
    selections.stepSelected = [[NSNumber alloc] initWithInteger:selectedSequence.getActualIndex];
    
    AMSequenceStep *selectedStep = (AMSequenceStep*)selectedSequence.getActualObject;
    AMStave *selectedStave = selectedStep.getStave;
    selections.barSelected = [[NSNumber alloc] initWithInteger:selectedStave.getActualIndex];
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
        CDStep *newStep = [self getCoreDataFromStep:sequence[(NSUInteger) i]
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
        CDBar *newBar = [self getCoreDataFromBar:stave[(NSUInteger) i]
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
