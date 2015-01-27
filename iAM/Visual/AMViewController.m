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

@interface AMViewController () {
}
@property AMSequencer *mainSequencer;

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

- (void)loadPickers{
    NSArray *sizePickerData = [self createRangeOfValuesStartingFrom:_mainSequencer.minLength
                                                               upTo:_mainSequencer.maxLength];
    _lengthPickerController = [[AMPickerController alloc] initWithPicker:_lengthPicker
                                                               dataArray:sizePickerData
                                                           andStartIndex:5];
    _lengthPickerController.delegate = self;

    NSArray *tempoPickerData = [self createRangeOfValuesStartingFrom:_mainSequencer.minTempo
                                                                upTo:_mainSequencer.maxTempo];
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
    _mainSequencer = nil;
    _lengthPickerController = nil;
    _tempoPickerController = nil;
}

- (IBAction)onClearEvent:(id)sender {
    [_mainSequencer clear];
    [_collectionViewController reloadData];
}

- (IBAction)onStartEvent:(id)sender {
    [_mainSequencer startStop];
}

- (void)pickerSelectionHasChanged{
    [self lengthHasBeenChanged:_lengthPickerController.getActualPickerValue];
    [self tempoHasBeenChanged:_tempoPickerController.getActualPickerValue];
    [_collectionViewController reloadData];
}

- (void)lengthHasBeenChanged:(NSString*)lengthText {
    NSInteger newLengthValue = [lengthText integerValue];

    if (![self isTextANumber:lengthText] || ![self isValue:newLengthValue
                                                withingMax:_mainSequencer.maxLength
                                                    andMin:_mainSequencer.minLength]) {
        return;
    }

    [_mainSequencer setLengthToBePlayed:newLengthValue];
}

- (void)tempoHasBeenChanged:(NSString*)tempoText {
    NSInteger newTempoValue = [tempoText integerValue];

    if (![self isTextANumber:tempoText] || ![self isValue:newTempoValue
                                               withingMax:_mainSequencer.maxTempo
                                                   andMin:_mainSequencer.minTempo]) {
        return;
    }

    [_mainSequencer setTempo:newTempoValue];
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

@end
