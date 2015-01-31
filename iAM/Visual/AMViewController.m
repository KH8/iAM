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

@property NSMutableArray *arrayOfSequencers;
@property AMSequencer *actuallySelectedSequencer;

@property AMCollectionViewController *collectionViewController;

@end

@implementation AMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainObjects];
    [self loadCollectionViewController];
    [self loadSidebarMenu];
}

- (void)viewDidDisappear:(BOOL)animated {
    if(_actuallySelectedSequencer.isRunning){
        [_actuallySelectedSequencer startStop];
        [_actuallySelectedSequencer killBackgroundThread];
    }
}

- (void)loadMainObjects{
    _arrayOfSequencers = [[NSMutableArray alloc] init];
    for (int i = 0; i < 1; ++i) {
        [self addNewSequencer];
    }
    _actuallySelectedSequencer = _arrayOfSequencers[0];
}

- (void)addNewSequencer{
    AMSequencer *newSequencer = [[AMSequencer alloc] init];
    newSequencer.sequencerDelegate = self;
    [_arrayOfSequencers addObject:newSequencer];
}

- (void)loadCollectionViewController{
    _collectionViewController = [[AMCollectionViewController alloc] initWithCollectionView:_collectionView
                                                                              andSequencer:_actuallySelectedSequencer];
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
    _actuallySelectedSequencer = nil;
}

- (IBAction)onClearEvent:(id)sender {
    [_actuallySelectedSequencer clear];
    [_collectionViewController reloadData];
}

- (IBAction)onStartEvent:(id)sender {
    [_actuallySelectedSequencer startStop];
}

- (void)valuesPickedLength:(NSNumber *)lengthPicked andTempo:(NSNumber *)tempoPicked{
    [self lengthHasBeenChanged:lengthPicked];
    [self tempoHasBeenChanged:tempoPicked];
    [_collectionViewController reloadData];
}

- (void)lengthHasBeenChanged:(NSNumber*)lengthText {
    NSInteger newLengthValue = [lengthText integerValue];
    if (![self isValue:newLengthValue
            withingMax:_actuallySelectedSequencer.maxLength
                andMin:_actuallySelectedSequencer.minLength]) {
        return;
    }
    [_actuallySelectedSequencer setLengthToBePlayed:newLengthValue];
}

- (void)tempoHasBeenChanged:(NSNumber*)tempoText {
    NSInteger newTempoValue = [tempoText integerValue];
    if (![self isValue:newTempoValue
            withingMax:_actuallySelectedSequencer.maxTempo
                andMin:_actuallySelectedSequencer.minTempo]) {
        return;
    }
    [_actuallySelectedSequencer setTempo:newTempoValue];
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
    _actuallySelectedSequencer = _arrayOfSequencers[(NSUInteger) _pageControl.currentPage];
    [_collectionViewController changeSequencerAssigned:_actuallySelectedSequencer];
}

- (IBAction)addPage:(id)sender {
    _pageControl.numberOfPages = _pageControl.numberOfPages + 1;
    [self addNewSequencer];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"sw_popover"]){
        AMPopoverViewController *popoverViewController = (AMPopoverViewController *)segue.destinationViewController;
        popoverViewController.actuallySelectedSequencer = _actuallySelectedSequencer;
        popoverViewController.delegate = self;
    }
}

@end
