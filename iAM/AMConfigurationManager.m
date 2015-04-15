//
//  AMConfigurationManager.m
//  iAM
//
//  Created by Krzysztof Reczek on 15.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMConfigurationManager.h"
#import "AMDataMapper.h"
#import "AMSequencerSingleton.h"
#import "AppDelegate.h"
#import "CDConfiguration.h"
#import "CDSelections.h"
#import "CDSequence.h"
#import "CDStep.h"
#import "CDNote.h"
#import "CDBar.h"

@implementation AMConfigurationManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)initSequenceCoreDataEntitiesInContext: (NSManagedObjectContext*)context {
    CDSequence *sequence = [NSEntityDescription insertNewObjectForEntityForName:@"CDSequence"
                                                         inManagedObjectContext:context];
    sequence.sequenceName = @"NEW SEQUENCE";
    sequence.sequenceCreationDate = [NSDate date];
    sequence.sequenceId = @0;
    
    CDStep *step = [NSEntityDescription insertNewObjectForEntityForName:@"CDStep"
                                                 inManagedObjectContext:context];
    step.stepName = @"NEW STEP";
    step.stepNumberOfLoops = @0;
    step.stepType = @3;
    step.stepTempo = @140;
    step.stepId = @0;
    step.sequence = sequence;
    [sequence addSequenceStepsObject:step];
    
    CDBar *bar = [NSEntityDescription insertNewObjectForEntityForName:@"CDBar"
                                               inManagedObjectContext:context];
    bar.barDensity = @4;
    bar.barSigNumerator = @4;
    bar.barSigDenominator = @4;
    bar.barId = @0;
    bar.step = step;
    [step addStepBarsObject:bar];
    
    CDNote *note = [NSEntityDescription insertNewObjectForEntityForName:@"CDNote"
                                                 inManagedObjectContext:context];
    note.noteCoordLine = @0;
    note.noteCoordPos = @0;
    note.bar = bar;
    [bar addBarNotesObject:note];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Core data error occured: %@", [error localizedDescription]);
    }
}

- (void)initSelectionsCoreDataEntitiesInContext: (NSManagedObjectContext*)context {
    CDSelections *selections = [NSEntityDescription insertNewObjectForEntityForName:@"CDSelections"
                                                             inManagedObjectContext:context];
    selections.barSelected = @0;
    selections.stepSelected = @0;
    selections.sequenceSelected = @0;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Core data error occured: %@", [error localizedDescription]);
    }
}

- (void)initConfigurationsCoreDataEntitiesInContext: (NSManagedObjectContext*)context {
    CDConfiguration *configuration = [NSEntityDescription insertNewObjectForEntityForName:@"CDConfiguration"
                                                                   inManagedObjectContext:context];
    configuration.soundTrack1Key = @"ARTIFICIAL HIGH 1";
    configuration.soundTrack1Value = @"artificialHigh1";
    configuration.soundTrack2Key = @"ARTIFICIAL LOW 1";
    configuration.soundTrack2Value = @"artificialLow1";
    configuration.soundTrack3Key = @"ARTIFICIAL LOW 2";
    configuration.soundTrack3Value = @"artificialLow2";
    configuration.volumeGeneral = @0.95;
    configuration.volumeTrack1 = @0.95;
    configuration.volumeTrack2 = @0.95;
    configuration.volumeTrack3 = @0.95;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Core data error occured: %@", [error localizedDescription]);
    }
}

- (void)loadContext {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Core data error occured: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDSequence"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if(fetchedObjects.count == 0){
        [self clearContext];
        [self initSequenceCoreDataEntitiesInContext:context];
        [self initSelectionsCoreDataEntitiesInContext:context];
        [self initConfigurationsCoreDataEntitiesInContext:context];
        [context executeFetchRequest:fetchRequest error:&error];
    }
    
    AMDataMapper *dataMapper = [[AMDataMapper alloc] init];
    AMSequencerSingleton *sequencerSingleton = [AMSequencerSingleton sharedSequencer];
    sequencerSingleton.arrayOfSequences = [dataMapper getActualConfigurationFromContext:context];
    
    AMSequencer *sequencer = sequencerSingleton.sequencer;
    [sequencer setSequence:(AMSequence *)sequencerSingleton.arrayOfSequences.getActualObject];
    [dataMapper getConfigurationOfSequencer:sequencer fronContext:context];
}

- (void)saveContext {
    [self clearContext];
    AMDataMapper *dataMapper = [[AMDataMapper alloc] init];
    AMSequencerSingleton *sequencerSingleton = [AMSequencerSingleton sharedSequencer];
    NSManagedObjectContext *context = [self managedObjectContext];
    [dataMapper getCoreDataFromActualConfiguration:sequencerSingleton.arrayOfSequences
                                         inContext:context];
    [dataMapper getCoreDataConfigurationOfSequencer:sequencerSingleton.sequencer
                                          inContext:context];
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)clearContext {
    [self clearContextWithEntity:@"CDSequence"];
    [self clearContextWithEntity:@"CDSelections"];
    [self clearContextWithEntity:@"CDConfiguration"];
}

- (void)clearContextWithEntity:(NSString*)entityString {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entityString inManagedObjectContext:context]];
    NSArray * result = [context executeFetchRequest:fetchRequest error:nil];
    for (id sequence in result)
        [context deleteObject:sequence];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AMDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AMDataModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
