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

@end

@implementation AMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainObjects];
    [self loadCollectionViewController];
    [self loadSidebarMenu];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    _collectionViewController = nil;
    _mainSequencer = nil;
}

- (IBAction)onClearEvent:(id)sender {
    [_mainSequencer clear];
    [_collectionViewController reloadData];
}

- (IBAction)onStartEvent:(id)sender {
    [_mainSequencer startStop];
}

- (void)valuesPickedLength:(NSNumber *)lengthPicked
                  andTempo:(NSNumber *)tempoPicked{
    [self lengthHasBeenChanged:lengthPicked];
    [self tempoHasBeenChanged:tempoPicked];
    [_collectionViewController reloadData];
}

- (void)lengthHasBeenChanged:(NSNumber*)lengthText {
    NSInteger newLengthValue = [lengthText integerValue];
    AMStave *stave = _mainSequencer.getStave;
    AMBar *bar = stave.getActualBar;
    if (![self isValue:newLengthValue
            withingMax:bar.maxLength
                andMin:bar.minLength]) {
        return;
    }
    [bar setLengthToBePlayed:newLengthValue];
}

- (void)tempoHasBeenChanged:(NSNumber*)tempoText {
    NSInteger newTempoValue = [tempoText integerValue];
    AMStave *stave = _mainSequencer.getStave;
    if (![self isValue:newTempoValue
            withingMax:stave.maxTempo
                andMin:stave.minTempo]) {
        return;
    }
    [stave setTempo:newTempoValue];
}

- (bool)isValue: (NSInteger)aValue
     withingMax: (NSInteger)aMaximum
         andMin: (NSInteger)aMinimum{
    return aValue <= aMaximum && aValue >= aMinimum;
}

- (void)sequenceHasStarted {
    [_startButton setTitle:@"Stop" forState:UIControlStateNormal];
}

- (void)sequenceHasStopped {
    [_startButton setTitle:@"Start" forState:UIControlStateNormal];
}

- (IBAction)pageSelectionHasChanged:(id)sender {
    if(_mainSequencer.isRunning){
        [_mainSequencer startStop];
    }
    AMStave *stave = _mainSequencer.getStave;
    [stave setIndexAsActual:_pageControl.currentPage];
}

- (IBAction)addPage:(id)sender {
    _pageControl.numberOfPages = _pageControl.numberOfPages + 1;
    AMStave *stave = _mainSequencer.getStave;
    [stave addBar];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"sw_popover"]){
        AMPopoverViewController *popoverViewController = (AMPopoverViewController *)segue.destinationViewController;
        popoverViewController.actuallySelectedSequencer = _mainSequencer;
        popoverViewController.delegate = self;
    }
}

@end
