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
@property AMPickerController *lengthPickerController;
@property AMPickerController *tempoPickerController;

@end

@implementation AMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainObjects];
    [self loadCollectionViewController];
    [self loadPickers];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
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

- (void)loadPickers{
    NSArray *sizePickerData = [self createRangeOfValuesStartingFrom:_actuallySelectedSequencer.minLength
                                                               upTo:_actuallySelectedSequencer.maxLength];
    _lengthPickerController = [[AMPickerController alloc] initWithPicker:_lengthPicker
                                                               dataArray:sizePickerData
                                                           andStartValue:@(_actuallySelectedSequencer.getLengthToBePlayed)];
    _lengthPickerController.delegate = self;
    NSArray *tempoPickerData = [self createRangeOfValuesStartingFrom:_actuallySelectedSequencer.minTempo
                                                                upTo:_actuallySelectedSequencer.maxTempo];
    _tempoPickerController = [[AMPickerController alloc] initWithPicker:_tempoPicker
                                                              dataArray:tempoPickerData
                                                          andStartValue:@(_actuallySelectedSequencer.getTempo)];
    _tempoPickerController.delegate = self;
}

- (NSMutableArray *)createRangeOfValuesStartingFrom: (NSInteger)startValue
                                               upTo: (NSInteger)endValue{
    NSMutableArray *anArray = [[NSMutableArray alloc] init];
    for (NSInteger i = startValue; i <= endValue; i++)
    {
        [anArray addObject:@(i)];
    }
    return anArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    _collectionViewController = nil;
    _actuallySelectedSequencer = nil;
    _lengthPickerController = nil;
    _tempoPickerController = nil;
}

- (IBAction)onClearEvent:(id)sender {
    [_actuallySelectedSequencer clear];
    [_collectionViewController reloadData];
}

- (IBAction)onStartEvent:(id)sender {
    [_actuallySelectedSequencer startStop];
}

- (void)pickerSelectionHasChanged{
    [self lengthHasBeenChanged:_lengthPickerController.getActualPickerValue];
    [self tempoHasBeenChanged:_tempoPickerController.getActualPickerValue];
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
    [_lengthPickerController setActualValue:@(_actuallySelectedSequencer.getLengthToBePlayed)];
    [_tempoPickerController setActualValue:@(_actuallySelectedSequencer.getTempo)];
}

- (IBAction)addPage:(id)sender {
    _pageControl.numberOfPages = _pageControl.numberOfPages + 1;
    [self addNewSequencer];
}

@end
