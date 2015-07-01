//
//  AMCollectionViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 06.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "SWRevealViewController.h"
#import "Utils/AMVisualUtils.h"
#import "Utils/AMRevealViewUtils.h"
#import "AppDelegate.h"
#import "AMApplicationDelegate.h"
#import "AMViewController.h"
#import "AMSequencerSingleton.h"
#import "AMPopupViewController.h"
#import "AMConfig.h"
#import "AMMutableArrayResponder.h"
#import "AMPlayer.h"

@import MediaPlayer;

@interface AMViewController () {
}

@property(weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property AMCollectionViewController *collectionViewController;

@property AMMutableArray *arrayOfSequences;
@property AMSequencer *mainSequencer;
@property AMSequence *mainSequence;
@property AMSequenceStep *mainStep;
@property AMStave *mainStave;

@property UIBarButtonItem *temporarySettingsButton;
@property UIBarButtonItem *temporaryPlayButton;
@property UIBarButtonItem *temporaryBackwardButton;
@property UIBarButtonItem *temporaryForwardButton;
@property UIBarButtonItem *temporaryEraserButton;
@property UIBarButtonItem *temporaryLeftButton;
@property UIBarButtonItem *temporaryRightButton;
@property UIBarButtonItem *temporaryDeleteButton;
@property UIBarButtonItem *temporaryAddButton;
@property UIBarButtonItem *temporaryDuplicateButton;
@property UIBarButtonItem *temporaryNextButton;
@property UIBarButtonItem *temporaryEditButton;

@property BOOL isEditEnabled;
@property NSMutableArray *toolbarItemsArray;

@property AMMutableArrayResponder *mainSequenceArrayResponder;
@property AMMutableArrayResponder *mainStaveArrayResponder;

@property MPNowPlayingInfoCenter *nowPlayingInfo;
@property MPMusicPlayerController *musicPlayer;

@end

@implementation AMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initResponders];
    [self initMainObjects];
    [self initCollectionViewController];
    [self initSidebarMenu];
    [self initBottomToolBar];
    [self initIcons];
    [self initSession];
    [self initTheme];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initAudioSession];
}

- (void)initAudioSession {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryMultiRoute
                                           error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    _musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMusicPlayerVolumeChangedNotification:)
                                                 name:MPMusicPlayerControllerVolumeDidChangeNotification
                                               object:_musicPlayer];
    [_musicPlayer beginGeneratingPlaybackNotifications];
    
    [self becomeFirstResponder];
    
    AMPlayer *testPlayer = [[AMPlayer alloc] initWithFile:@"click1" andKey:@"" ofType:@"aif"];
    [testPlayer playSound];
}

- (void)viewDidDisappear:(BOOL)animated {
    if (_mainSequencer.isRunning) {
        [_mainSequencer startStop];
        [_mainSequencer killBackgroundThread];
    }
    [NSThread sleepForTimeInterval:0.2];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
}

- (void)initResponders {
    _mainSequenceArrayResponder = [[AMMutableArrayResponder alloc] initWithArrayHasChangedAction:@selector(sequenceArrayHasBeenChanged)
                                                                    andSelectionHasChangedAction:@selector(sequenceSelectionHasBeenChanged)
                                                                       andMaxCountExceededAction:@selector(sequenceMaxCountExceeded)
                                                                                       andTarget:self];
    _mainStaveArrayResponder = [[AMMutableArrayResponder alloc] initWithArrayHasChangedAction:@selector(staveArrayHasBeenChanged)
                                                                 andSelectionHasChangedAction:@selector(staveSelectionHasBeenChanged)
                                                                    andMaxCountExceededAction:@selector(staveMaxCountExceeded)
                                                                                    andTarget:self];
}

- (void)initMainObjects {
    AMSequencerSingleton *sequencerSingleton = [AMSequencerSingleton sharedSequencer];
    _arrayOfSequences = sequencerSingleton.arrayOfSequences;
    _mainSequencer = sequencerSingleton.sequencer;
    [_mainSequencer addSequencerDelegate:self];
    [self updateComponents];
}

- (void)initCollectionViewController {
    _collectionViewController = [[AMCollectionViewController alloc] initWithCollectionView:_collectionView
                                                                              andSequencer:_mainSequencer];
    _collectionView.delegate = _collectionViewController;
    _collectionView.dataSource = _collectionViewController;
}

- (void)initSidebarMenu {
    SWRevealViewController *revealController = [self revealViewController];
    [AMRevealViewUtils initRevealController:revealController
                            withRightButton:self.listButton
                              andLeftButton:self.sideMenuButton];
}

- (void)initBottomToolBar {
    [_bottomToolBar setBarTintColor:[AMAppearanceManager getGlobalColorTheme]];
    _toolbarItemsArray = [[NSMutableArray alloc] init];

    [self showDescriptionLabel];
    [self showAudioButtons];
    [_toolbarItemsArray addObject:[AMVisualUtils createFlexibleSpace]];
    [self showSettingButton];
    [_toolbarItemsArray addObject:[AMVisualUtils createFlexibleSpace]];
    [self showEditButtons];

    NSString *editButtonImage = @"edit.png";
    if (_isEditEnabled) {
        editButtonImage = @"details.png";
    } else {
        _temporaryNextButton = [AMVisualUtils createBarButton:@"next.png"
                                                       targer:self
                                                     selector:@selector(onNextStep:)
                                                         size:26];
        [_toolbarItemsArray addObject:_temporaryNextButton];
    }

    _temporaryEditButton = [AMVisualUtils createBarButton:editButtonImage
                                                   targer:self
                                                 selector:@selector(onEditPressed:)
                                                     size:30];
    [_toolbarItemsArray addObject:_temporaryEditButton];
    [AMVisualUtils applyObjectsToToolBar:_bottomToolBar
                             fromAnArray:_toolbarItemsArray];
}

- (void)showDescriptionLabel {
    [_descriptionLabel setText:@""];
    if (!_isEditEnabled) {
        NSString *newDescription = [self getDescriptionLabel];
        [_descriptionLabel setText:newDescription];
    }
}

- (NSString *)getDescriptionLabel {
    NSString *squenceDescription = [NSString stringWithFormat:@"SEQ: %@",
                                    _mainSequence.getName];
    NSString *stepDescription = [NSString stringWithFormat:@"STEP: %@ %@",
                                 _mainStep.getName,
                                 _mainStep.getStepTypeName];
    NSString *loopDescription = @"";
    if (_mainStep.getStepType == REPEAT) {
        loopDescription = [NSString stringWithFormat:@" %ld/%ld",
                           (long) _mainSequence.getActualLoopCount + 1,
                           _mainStep.getNumberOfLoops];
    }
    NSString *barDescription = [NSString stringWithFormat:@"BAR: %ld/%ld",
                                _mainStave.getActualIndex + 1,
                                _mainStave.count];
    return [NSString stringWithFormat:@"%@ | %@%@ | %@",
            squenceDescription,
            stepDescription,
            loopDescription,
            barDescription];
}

- (void)showSettingButton {
    if (!_isEditEnabled) {
        AMBar *bar = (AMBar *) _mainStave.getActualObject;
        NSString *newTitle = [NSString stringWithFormat:@"%ld:%ld x%ld %ld BPM",
                                                        (long) bar.getSignatureNumerator,
                                                        (long) bar.getSignatureDenominator,
                                                        (long) bar.getDensity,
                                                        (long) _mainStave.getTempo];
        _temporarySettingsButton = [AMVisualUtils createBarButtonWithText:newTitle
                                                                   targer:self
                                                                 selector:@selector(onShowSettings:)];
        [_toolbarItemsArray addObject:_temporarySettingsButton];
    }
}

- (void)showAudioButtons {
    if (_temporaryPlayButton == nil) {
        _temporaryPlayButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                             target:self
                                                                             action:@selector(onPlayButtonTouchedEvent:)];
        _temporaryBackwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind
                                                                                 target:self
                                                                                 action:@selector(onPreviousSequence:)];
        _temporaryForwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                                target:self
                                                                                action:@selector(onNextSequence:)];
    }
    [_toolbarItemsArray addObject:_temporaryBackwardButton];
    [_toolbarItemsArray addObject:[AMVisualUtils createFixedSpaceWithSize:15.0f]];
    [_toolbarItemsArray addObject:_temporaryPlayButton];
    [_toolbarItemsArray addObject:[AMVisualUtils createFixedSpaceWithSize:15.0f]];
    [_toolbarItemsArray addObject:_temporaryForwardButton];
}

- (void)showEditButtons {
    if (_isEditEnabled) {
        _temporaryLeftButton = [AMVisualUtils createBarButton:@"left.png"
                                                       targer:self
                                                     selector:@selector(onMovePageBackward:)
                                                         size:30];
        _temporaryRightButton = [AMVisualUtils createBarButton:@"right.png"
                                                        targer:self
                                                      selector:@selector(onMovePageForward:)
                                                          size:30];
        _temporaryEraserButton = [AMVisualUtils createBarButton:@"eraser.png"
                                                         targer:self
                                                       selector:@selector(onClear:)
                                                           size:30];
        _temporaryDeleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                               target:self
                                                                               action:@selector(onRemovePage:)];
        _temporaryAddButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(onAddPage:)];
        _temporaryDuplicateButton = [AMVisualUtils createBarButton:@"copy.png"
                                                            targer:self
                                                          selector:@selector(onDuplicatePage:)
                                                              size:30];
        [_toolbarItemsArray addObject:_temporaryLeftButton];
        [_toolbarItemsArray addObject:[AMVisualUtils createFixedSpaceWithSize:10.0f]];
        [_toolbarItemsArray addObject:_temporaryRightButton];
        [_toolbarItemsArray addObject:[AMVisualUtils createFixedSpaceWithSize:10.0f]];
        [_toolbarItemsArray addObject:_temporaryEraserButton];
        [_toolbarItemsArray addObject:[AMVisualUtils createFixedSpaceWithSize:10.0f]];
        [_toolbarItemsArray addObject:_temporaryDeleteButton];
        [_toolbarItemsArray addObject:[AMVisualUtils createFixedSpaceWithSize:10.0f]];
        [_toolbarItemsArray addObject:_temporaryAddButton];
        [_toolbarItemsArray addObject:[AMVisualUtils createFixedSpaceWithSize:10.0f]];
        [_toolbarItemsArray addObject:_temporaryDuplicateButton];
        [_toolbarItemsArray addObject:[AMVisualUtils createFixedSpaceWithSize:10.0f]];
    }
}

- (void)initIcons {
    UIBarButtonItem *originalLeftButton = self.navigationItem.leftBarButtonItem;
    self.navigationItem.leftBarButtonItem = [AMVisualUtils createBarButton:@"menu.png"
                                                                    targer:originalLeftButton.target
                                                                  selector:originalLeftButton.action
                                                                      size:26];
    UIBarButtonItem *originalRightButton = self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = [AMVisualUtils createBarButton:@"sequence.png"
                                                                     targer:originalRightButton.target
                                                                   selector:originalRightButton.action
                                                                       size:26];
}

- (void)initSession {
    [self updateSession];
}

- (void)updateSession {
    NSString *squenceDescription = [NSString stringWithFormat:@"SEQ: %@", _mainSequence.getName];
    NSNumber *rate = [NSNumber numberWithFloat:(_mainSequencer.isRunning ? 1.0f : 0.0f)];
    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
    
    NSArray *keys = [NSArray arrayWithObjects:MPMediaItemPropertyAlbumTitle, MPNowPlayingInfoPropertyPlaybackRate, MPMediaItemPropertyArtwork, nil];
    NSArray *values = [NSArray arrayWithObjects:squenceDescription, rate, albumArt, nil];
    NSDictionary *mediaInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    _nowPlayingInfo = [MPNowPlayingInfoCenter defaultCenter];
    [_nowPlayingInfo setNowPlayingInfo:mediaInfo];
}

- (void)initTheme {
    UIColor *globalColorTheme = [AMAppearanceManager getGlobalColorTheme];
    UIColor *globalTintColor = [AMAppearanceManager getGlobalTintColor];
    [_bottomToolBar setTintColor:globalTintColor];
    [_bottomToolBar setBarTintColor:globalColorTheme];
    [_pageControl setCurrentPageIndicatorTintColor:globalTintColor];
    [_descriptionLabel setTextColor:[UIColor lightGrayColor]];
    [self.navigationController.navigationBar setTintColor:globalTintColor];
    [self.navigationController.navigationBar setBarTintColor:globalColorTheme];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    _collectionViewController = nil;
    _mainSequencer = nil;
}

- (IBAction)onPlayButtonTouchedEvent:(id)sender {
    [self saveConfiguration];
    [_mainSequencer startStop];
}

- (void)saveConfiguration {
    AppDelegate *appDelegate = [AMApplicationDelegate getAppDelegate];
    [[appDelegate configurationManager] saveContext];
    [[appDelegate appearanceManager] saveContext];
}

- (IBAction)onMovePageBackward:(id)sender {
    [_mainStave moveActualObjectBackward];
}

- (IBAction)onMovePageForward:(id)sender {
    [_mainStave moveActualObjectForward];
}

- (IBAction)onClear:(id)sender {
    [_mainSequencer clear];
    [_collectionViewController reloadData];
}

- (IBAction)onAddPage:(id)sender {
    [_mainStave addBar];
}

- (IBAction)onRemovePage:(id)sender {
    [_mainStave removeActualObject];
}

- (IBAction)onDuplicatePage:(id)sender {
    [_mainStave duplicateObject];
}

- (IBAction)onEditPressed:(id)sender {
    _isEditEnabled = !_isEditEnabled;
    [self initBottomToolBar];
}

- (IBAction)onPageSelectionHasChangedEvent:(id)sender {
    if (_mainSequencer.isRunning) {
        [_mainSequencer startStop];
    }
    AMSequenceStep *sequenceStep = (AMSequenceStep *) _mainSequence.getActualObject;
    AMStave *stave = sequenceStep.getStave;
    [stave setIndexAsActual:(NSUInteger) _pageControl.currentPage];
}

- (IBAction)onShowSettings:(id)sender {
    [self performSegueWithIdentifier:@"sw_popover" sender:self];
}

- (IBAction)onPreviousStep:(id)sender {
    [_mainSequence setOneStepBackward];
}

- (IBAction)onNextStep:(id)sender {
    [_mainSequence setOneStepForward];
}

- (IBAction)onPreviousSequence:(id)sender {
    [_arrayOfSequences setPreviousIndexAsActual];
    [self changeSequencer];
}

- (IBAction)onNextSequence:(id)sender {
    [_arrayOfSequences setNextIndexAsActual];
    [self changeSequencer];
}

- (void)changeSequencer {
    bool wasRunning = [_mainSequencer isRunning];
    AMSequence *sequenceSelected = (AMSequence *) _arrayOfSequences.getActualObject;
    [_mainSequencer setSequence:sequenceSelected];
    if (wasRunning) {
        [_mainSequencer startStop];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"sw_popover"]) {
        AMPopoverViewController *popoverViewController = (AMPopoverViewController *) segue.destinationViewController;
        popoverViewController.actuallySelectedSequencer = _mainSequencer;
        popoverViewController.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"sw_bar_popup"]) {
        AMPopupViewController *popupViewController = (AMPopupViewController *) segue.destinationViewController;
        [popupViewController setText:[AMConfig barCountExceeded]];
    }
}

- (void)pickedValuesHaveBeenChanged {
    [self initBottomToolBar];
}

- (void)staveArrayHasBeenChanged {
    [self updateComponents];
}

- (void)staveSelectionHasBeenChanged {
    [self updateComponents];
}

- (void)staveMaxCountExceeded {
    if (_mainStave.count >= [AMConfig maxBarCount]) {
        [self performSegueWithIdentifier:@"sw_bar_popup" sender:self];
    }
}

- (void)sequenceArrayHasBeenChanged {
    [self updateComponents];
}

- (void)sequenceSelectionHasBeenChanged {
    [self updateComponents];
}

- (void)sequenceMaxCountExceeded {

}

- (void)sequenceStepPropertiesHasBeenChanged {
    [self updateComponents];
}

- (void)sequenceHasStarted {
    _temporaryPlayButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause
                                                                         target:self
                                                                         action:@selector(onPlayButtonTouchedEvent:)];
    [self initBottomToolBar];
    [self updateSession];
}

- (void)sequenceHasStopped {
    _temporaryPlayButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                         target:self
                                                                         action:@selector(onPlayButtonTouchedEvent:)];
    [self initBottomToolBar];
    [self updateSession];
}

- (void)sequenceHasChanged {
    [self updateComponents];
}

- (void)updateComponents {
    _mainSequence = _mainSequencer.getSequence;
    [_mainSequence addArrayDelegate:_mainSequenceArrayResponder];

    _mainStep = (AMSequenceStep *) _mainSequence.getActualObject;
    [_mainStep addStepDelegate:self];

    AMSequenceStep *sequenceStep = (AMSequenceStep *) _mainSequence.getActualObject;
    _mainStave = sequenceStep.getStave;
    [_mainStave addArrayDelegate:_mainStaveArrayResponder];

    [self updatePageControl];
    [self initBottomToolBar];
    [self updateSession];

    [_collectionViewController reloadData];
}

- (void)updatePageControl {
    _pageControl.numberOfPages = _mainStave.count;
    _pageControl.currentPage = _mainStave.getActualIndex;
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void) remoteControlReceivedWithEvent: (UIEvent*) event {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [self onPlayButtonTouchedEvent:nil];
            break;
        case UIEventSubtypeRemoteControlPause:
            [self onPlayButtonTouchedEvent:nil];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self onNextSequence:nil];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self onPreviousSequence:nil];
            break;
        default:
            break;
    }
    [self updateSession];
}

-(void)handleMusicPlayerVolumeChangedNotification: (id)notification {
    NSArray *arrayOfPlayers = _mainSequencer.getArrayOfPlayers;
    float volume = [(MPMusicPlayerController*)[notification object] volume];
    [(AMPlayer *) arrayOfPlayers[0] setGeneralVolumeFactor:[[NSNumber alloc] initWithFloat:volume]];
    [(AMPlayer *) arrayOfPlayers[1] setGeneralVolumeFactor:[[NSNumber alloc] initWithFloat:volume]];
    [(AMPlayer *) arrayOfPlayers[2] setGeneralVolumeFactor:[[NSNumber alloc] initWithFloat:volume]];
}

@end
