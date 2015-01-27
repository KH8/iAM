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
@property AMSequence *mainSequence;

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
    if(_mainSequence.isRunning){
        [_mainSequence startStop];
        [_mainSequence killBackgroundThread];
    }
}

- (void)loadMainObjects{
    _mainSequence = [[AMSequence alloc] init];
    _mainSequence.sequenceDelegate = self;
}

- (void)loadCollectionViewController{
    _collectionViewController = [[AMCollectionViewController alloc] initWithCollectionView:_collectionView
                                                                               andSequence:_mainSequence];
    _collectionView.delegate = _collectionViewController;
    _collectionView.dataSource = _collectionViewController;
}

- (void)loadPickers{
    NSArray *sizePickerData = [self createRangeOfValuesStartingFrom:_mainSequence.minLength
                                                               upTo:_mainSequence.maxLength];
    _lengthPickerController = [[AMPickerController alloc] initWithPicker:_lengthPicker
                                                               dataArray:sizePickerData
                                                           andStartIndex:5];
    _lengthPickerController.delegate = self;

    NSArray *tempoPickerData = [self createRangeOfValuesStartingFrom:_mainSequence.minTempo
                                                                upTo:_mainSequence.maxTempo];
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
    _mainSequence = nil;
    _lengthPickerController = nil;
    _tempoPickerController = nil;
}

- (IBAction)onClearEvent:(id)sender {
    [_mainSequence clear];
    [_collectionViewController reloadData];
}

- (IBAction)onStartEvent:(id)sender {
    [_mainSequence startStop];
}

- (void)pickerSelectionHasChanged{
    [self lengthHasBeenChanged:_lengthPickerController.getActualPickerValue];
    [self tempoHasBeenChanged:_tempoPickerController.getActualPickerValue];
    [_collectionViewController reloadData];
}

- (void)lengthHasBeenChanged:(NSString*)lengthText {
    NSInteger newLengthValue = [lengthText integerValue];

    if (![self isTextANumber:lengthText] || ![self isValue:newLengthValue
                                                withingMax:_mainSequence.maxLength
                                                    andMin:_mainSequence.minLength]) {
        return;
    }

    [_mainSequence setLengthToBePlayed:newLengthValue];
}

- (void)tempoHasBeenChanged:(NSString*)tempoText {
    NSInteger newTempoValue = [tempoText integerValue];

    if (![self isTextANumber:tempoText] || ![self isValue:newTempoValue
                                               withingMax:_mainSequence.maxTempo
                                                   andMin:_mainSequence.minTempo]) {
        return;
    }

    [_mainSequence setTempo:newTempoValue];
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
