//
//  AppDelegate.m
//  iAM
//
//  Created by Krzysztof Reczek on 06.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequencerSingleton.h"
#import "AMDataMapper.h"
#import "AppDelegate.h"
#import "CDStep.h"
#import "CDSequence.h"
#import "CDNote.h"
#import "CDBar.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Core data error occured: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sequence"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if(fetchedObjects.count == 0){
        [self initCoreDataEntitiesInContext:context];
        fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    }
    
    AMDataMapper *dataMapper = [[AMDataMapper alloc] init];
    AMSequencerSingleton *sequencerSingleton = [AMSequencerSingleton sharedSequencer];
    sequencerSingleton.arrayOfSequences = [dataMapper getActualConfigurationFromContext:context];
    [sequencerSingleton.sequencer setSequence:sequencerSingleton.arrayOfSequences[0]];

    return YES;
}

- (void)initCoreDataEntitiesInContext: (NSManagedObjectContext*)context{
    CDSequence *sequence = [NSEntityDescription insertNewObjectForEntityForName:@"Sequence"
                                                       inManagedObjectContext:context];
    sequence.sequenceName = @"NEW SEQUENCE432";
    sequence.sequenceCreationDate = [NSDate date];
    
    CDStep *step = [NSEntityDescription insertNewObjectForEntityForName:@"Step"
                                               inManagedObjectContext:context];
    step.stepName = @"NEW STEP432";
    step.stepNumberOfLoops = @0;
    step.stepType = @2;
    step.stepTempo = @120;
    step.sequence = sequence;
    [sequence addSequenceStepsObject:step];
    
    CDBar *bar = [NSEntityDescription insertNewObjectForEntityForName:@"Bar"
                                             inManagedObjectContext:context];
    bar.barDensity = @4;
    bar.barSigNumerator = @1;
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
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
