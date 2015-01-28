//
//  AMCollectionViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 06.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMViewController.h"
#import "AMStave.h"
#import "AMPickerController.h"
#import "AMLogger.h"

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
}

- (void)viewDidDisappear:(BOOL)animated {
    if(_actuallySelectedSequencer.isRunning){
        [_actuallySelectedSequencer startStop];
        [_actuallySelectedSequencer killBackgroundThread];
    }
}

- (void)loadMainObjects{
    _arrayOfSequencers = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; ++i) {
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
                                                           andStartIndex:13];
    _lengthPickerController.delegate = self;

    NSArray *tempoPickerData = [self createRangeOfValuesStartingFrom:_actuallySelectedSequencer.minTempo
                                                                upTo:_actuallySelectedSequencer.maxTempo];
    _tempoPickerController = [[AMPickerController alloc] initWithPicker:_tempoPicker
                                                              dataArray:tempoPickerData
                                                          andStartIndex:60];
    _tempoPickerController.delegate = self;
}

- (NSMutableArray *)createRangeOfValuesStartingFrom: (NSInteger)startValue
                                               upTo: (NSInteger)endValue{
    NSMutableArray *anArray = [[NSMutableArray alloc] init];
    for (NSInteger i = startValue; i <= endValue; i++)
    {
        [anArray addObject:[NSString stringWithFormat:@"%d", i]];
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

- (void)lengthHasBeenChanged:(NSString*)lengthText {
    NSInteger newLengthValue = [lengthText integerValue];
    if (![self isTextANumber:lengthText] || ![self isValue:newLengthValue
                                                withingMax:_actuallySelectedSequencer.maxLength
                                                    andMin:_actuallySelectedSequencer.minLength]) {
        return;
    }
    [_actuallySelectedSequencer setLengthToBePlayed:newLengthValue];
}

- (void)tempoHasBeenChanged:(NSString*)tempoText {
    NSInteger newTempoValue = [tempoText integerValue];
    if (![self isTextANumber:tempoText] || ![self isValue:newTempoValue
                                               withingMax:_actuallySelectedSequencer.maxTempo
                                                   andMin:_actuallySelectedSequencer.minTempo]) {
        return;
    }
    [_actuallySelectedSequencer setTempo:newTempoValue];
}

- (bool)isTextANumber: (NSString *)aString{
    NSCharacterSet *alphaNumbers = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:aString];
    return [alphaNumbers isSupersetOfSet:inStringSet];
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
    _actuallySelectedSequencer = _arrayOfSequencers[_pageControl.currentPage];
    [_collectionViewController changeSequencerAssigned:_actuallySelectedSequencer];
}

- (IBAction)addPage:(id)sender {
    _pageControl.numberOfPages = _pageControl.numberOfPages + 1;
    [self addNewSequencer];
}

@end
