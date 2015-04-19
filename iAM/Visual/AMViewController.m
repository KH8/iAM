//
//  AMCollectionViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 06.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMViewController.h"
#import "SWRevealViewController.h"
#import "AMSequencerSingleton.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AMViewController () {
}

@property AMCollectionViewController *collectionViewController;
@property AMSequencer *mainSequencer;
@property AMSequence *mainSequence;
@property AMStave *mainStave;
@property UIBarButtonItem *temporaryPlayButton;
@property UIBarButtonItem *temporarySettingsButton;

@end

@implementation AMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainObjects];
    [self loadCollectionViewController];
    [self loadSidebarMenu];
    [self loadToolBar];
    [self loadBackgroundAudioSession];
    [self loadIcons];
}

- (void)viewDidDisappear:(BOOL)animated {
    if(_mainSequencer.isRunning){
        [_mainSequencer startStop];
        [_mainSequencer killBackgroundThread];
    }
}

- (void)loadMainObjects{
    AMSequencerSingleton *sequencerSingleton = [AMSequencerSingleton sharedSequencer];
    _mainSequencer = sequencerSingleton.sequencer;
    [_mainSequencer addSequencerDelegate:self];
    [self updateComponents];
}

- (void)loadCollectionViewController{
    _collectionViewController = [[AMCollectionViewController alloc] initWithCollectionView:_collectionView
                                                                              andSequencer:_mainSequencer];
    _collectionView.delegate = _collectionViewController;
    _collectionView.dataSource = _collectionViewController;
}

- (void)loadSidebarMenu{
    SWRevealViewController *revealController = [self revealViewController];
    
    float menuWindowSize = [UIScreen mainScreen].bounds.size.height / 6.0;
    [revealController setRearViewRevealWidth:menuWindowSize + 5];
    [revealController setRearViewRevealOverdraw:menuWindowSize + 20];
    
    [revealController setRightViewRevealWidth:280];
    [revealController setRightViewRevealOverdraw:60];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    [self.sideMenuButton setTarget: self.revealViewController];
    [self.sideMenuButton setAction: @selector( revealToggle: )];
    [self.listButton setTarget: self.revealViewController];
    [self.listButton setAction: @selector( rightRevealToggle: )];
}

- (void)loadToolBar{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                                                           action:@selector(onRemovePage:)];
    [[_bottomToolBar subviews][6] addGestureRecognizer:longPress];
}

- (void)loadBackgroundAudioSession{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryMultiRoute error:nil];
}

- (void)loadIcons{
    UIBarButtonItem *originalLeftButton = self.navigationItem.leftBarButtonItem;
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.tintColor = [[UIView appearance] tintColor];
    face.bounds = CGRectMake( 26, 26, 26, 26 );
    [face setImage:[[UIImage imageNamed:@"menu.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
          forState:UIControlStateNormal];
    [face addTarget:originalLeftButton.target
             action:originalLeftButton.action
   forControlEvents:UIControlEventTouchDown];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:face];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    _collectionViewController = nil;
    _mainSequencer = nil;
}

- (IBAction)onPlayButtonTouchedEvent:(id)sender {
    [_mainSequencer startStop];
    if(_mainSequencer.isRunning){
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self saveConfiguration];
    }
    else{
        [[AVAudioSession sharedInstance] setActive: NO error: nil];
        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    }
}

- (void)saveConfiguration{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate configurationManager] saveContext];
    [[appDelegate appearanceManager] saveContext];
}

- (IBAction)onClearEvent:(id)sender {
    [_mainSequencer clear];
    [_collectionViewController reloadData];
}

- (IBAction)onAddPageEvent:(id)sender {
    [_mainStave addBar];
}

- (void)onRemovePage:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
    }
    else if (sender.state == UIGestureRecognizerStateBegan){
        [_mainStave removeActualObject];
    }
}

- (IBAction)onPageSelectionHasChangedEvent:(id)sender {
    if(_mainSequencer.isRunning){
        [_mainSequencer startStop];
    }
    AMSequenceStep *sequenceStep = (AMSequenceStep *)_mainSequence.getActualObject;
    AMStave *stave = sequenceStep.getStave;
    [stave setIndexAsActual:(NSUInteger) _pageControl.currentPage];
}

- (IBAction)onShowSettings:(id)sender {
    [self performSegueWithIdentifier: @"sw_popover" sender: self];
}

- (IBAction)onPreviousStep:(id)sender {
    [_mainSequence setOneStepBackward];
}

- (IBAction)onNextStep:(id)sender {
    [_mainSequence setOneStepForward];
}

- (void)replaceObjectInToolBarAtIndex: (NSInteger)anIndex
                           withObject: (NSObject*)anObject{
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    for (NSObject *item in _bottomToolBar.items) {
        [toolbarItems addObject:item];
    }
    toolbarItems[(NSUInteger) anIndex] = anObject;
    _bottomToolBar.items = toolbarItems;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"sw_popover"]){
        AMPopoverViewController *popoverViewController = (AMPopoverViewController *)segue.destinationViewController;
        popoverViewController.actuallySelectedSequencer = _mainSequencer;
        popoverViewController.delegate = self;
    }
}

- (void)pickedValuesHaveBeenChanged{
    [self updateSettingsButton];
}

- (void)arrayHasBeenChanged {
    [self updateComponents];
}

- (void)selectionHasBeenChanged {
    [self updateComponents];
}

- (void)sequenceHasStarted {
    _temporaryPlayButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause
                                                                         target:self
                                                                         action:@selector(onPlayButtonTouchedEvent:)];
    [self replaceObjectInToolBarAtIndex:2 withObject:_temporaryPlayButton];
}

- (void)sequenceHasStopped {
    _temporaryPlayButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                         target:self
                                                                         action:@selector(onPlayButtonTouchedEvent:)];
    [self replaceObjectInToolBarAtIndex:2 withObject:_temporaryPlayButton];
}

- (void)sequenceHasChanged {
    [self updateComponents];
}

- (void)updateComponents{
    _mainSequence = _mainSequencer.getSequence;
    [_mainSequence addArrayDelegate:self];
    
    AMSequenceStep *sequenceStep = (AMSequenceStep *)_mainSequence.getActualObject;
    _mainStave = sequenceStep.getStave;
    [_mainStave addArrayDelegate:self];

    [self updatePageControl];
    [self updateSettingsButton];

    [_collectionViewController reloadData];
}

- (void)updateSettingsButton{
    AMBar *bar = (AMBar *)_mainStave.getActualObject;
    NSString *newTitle = [NSString stringWithFormat:@"%ld:%ld x%ld %ld BPM",
                                                    (long)bar.getSignatureNumerator,
                                                    (long)bar.getSignatureDenominator,
                                                    (long)bar.getDensity,
                                                    (long)_mainStave.getTempo];
    _temporarySettingsButton = [[UIBarButtonItem alloc] initWithTitle:newTitle
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(onShowSettings:)];
    [self replaceObjectInToolBarAtIndex:6 withObject:_temporarySettingsButton];
}

- (void)updatePageControl {
    _pageControl.numberOfPages = _mainStave.count;
    _pageControl.currentPage = _mainStave.getActualIndex;
}


@end
