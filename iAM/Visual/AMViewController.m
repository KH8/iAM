//
//  AMCollectionViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 06.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMViewController.h"
#import "SWRevealViewController.h"

@interface AMViewController () {
}

@property AMCollectionViewController *collectionViewController;
@property AMSequencer *mainSequencer;
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
}

- (void)viewDidDisappear:(BOOL)animated {
    if(_mainSequencer.isRunning){
        [_mainSequencer startStop];
        [_mainSequencer killBackgroundThread];
    }
}

- (void)loadMainObjects{
    _mainSequencer = [[AMSequencer alloc] init];
    _mainSequencer.sequencerDelegate = self;
    _mainStave = _mainSequencer.getStave;
    _mainStave.visualPageViewDelegate = self;
}

- (void)loadCollectionViewController{
    _collectionViewController = [[AMCollectionViewController alloc] initWithCollectionView:_collectionView
                                                                              andSequencer:_mainSequencer];
    _collectionView.delegate = _collectionViewController;
    _collectionView.dataSource = _collectionViewController;
}

- (void)loadSidebarMenu{
    SWRevealViewController *revealController = [self revealViewController];
    
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
    [[[_bottomToolBar subviews] objectAtIndex:6] addGestureRecognizer:longPress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    _collectionViewController = nil;
    _mainSequencer = nil;
}

- (IBAction)onPlayButtonTouchedEvent:(id)sender {
    [_mainSequencer startStop];
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
        [_mainStave removeActualBar];
    }
}

- (IBAction)onPageSelectionHasChangedEvent:(id)sender {
    if(_mainSequencer.isRunning){
        [_mainSequencer startStop];
    }
    AMStave *stave = _mainSequencer.getStave;
    [stave setIndexAsActual:_pageControl.currentPage];
}

- (IBAction)onShowSettings:(id)sender {
    [self performSegueWithIdentifier: @"sw_popover" sender: self];
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


- (void)replaceObjectInToolBarAtIndex: (NSInteger)anIndex withObject: (NSObject*)anObject{
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    for (NSObject *item in _bottomToolBar.items) {
        [toolbarItems addObject:item];
    }
    [toolbarItems replaceObjectAtIndex:anIndex withObject:anObject];
    _bottomToolBar.items = toolbarItems;
}

- (void)barHasBeenChanged {
    _pageControl.currentPage = _mainStave.getActualIndex;
    _pageControl.numberOfPages = _mainStave.getSize;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"sw_popover"]){
        AMPopoverViewController *popoverViewController = (AMPopoverViewController *)segue.destinationViewController;
        popoverViewController.actuallySelectedSequencer = _mainSequencer;
        popoverViewController.delegate = self;
    }
}

- (void)pickedValuesHaveBeenChanged{
    AMBar *bar = _mainStave.getActualBar;
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

@end
