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

@property AMCollectionViewController *collectionViewController;
@property AMPickerController *lengthPickerController;
@property AMPickerController *tempoPickerController;

@end

@implementation AMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _collectionViewController = [[AMCollectionViewController alloc] initWithCollectionView:_collectionView];
    _collectionView.delegate = _collectionViewController;
    _collectionView.dataSource = _collectionViewController;
    
    _mainSequencer = [[AMSequencer alloc] init];
    [_mainSequencer initializeWithStave:_collectionViewController.mainStave];
    _mainSequencer.delegate = self;

    NSArray *sizePickerData = @[@"3",@"4",@"6",@"8",@"9",@"12",@"16"];
    _lengthPickerController = [[AMPickerController alloc] initWithDataArray:sizePickerData];
    _lengthPickerController.delegate = self;
    _lengthPicker.delegate = _lengthPickerController;
    _lengthPicker.dataSource = _lengthPickerController;

    NSArray *tempoPickerData = @[@"60",@"100",@"140",@"180",@"220",@"260",@"300"];
    _tempoPickerController = [[AMPickerController alloc] initWithDataArray:tempoPickerData];
    _tempoPickerController.delegate = self;
    _tempoPicker.delegate = _tempoPickerController;
    _tempoPicker.dataSource = _tempoPickerController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [_mainSequencer killBackgroundThread];
    _mainSequencer = nil;
}

- (IBAction)onClearEvent:(id)sender {
    [_collectionViewController.mainStave clear];
    [_collectionViewController reloadData];
}

- (IBAction)onStartEvent:(id)sender {
    [_mainSequencer startStop];
}

- (void)sequencerHasStarted {
    [_startButton setTitle:@"Stop" forState:UIControlStateNormal];
}

- (void)sequencerHasStopped {
    [_startButton setTitle:@"Start" forState:UIControlStateNormal];
}

- (void)pickerSelectionHasChanged{
    [self lengthHasBeenChanged:_lengthPickerController.getActualPickerValue];
    [self tempoHasBeenChanged:_tempoPickerController.getActualPickerValue];
}

- (void)lengthHasBeenChanged:(NSString*)lengthText {
    NSInteger newLengthValue = [lengthText integerValue];

    if (![self isTextANumber:lengthText] || ![self isValue:newLengthValue withingMax:_mainSequencer.maxLength andMin:_mainSequencer.minLength]) {
        return;
    }

    [_mainSequencer setLengthToBePlayed:newLengthValue];
    [_collectionViewController setLengthToBeDisplayed:newLengthValue];
}

- (void)tempoHasBeenChanged:(NSString*)tempoText {
    NSInteger newTempoValue = [tempoText integerValue];

    if (![self isTextANumber:tempoText] || ![self isValue:newTempoValue withingMax:_mainSequencer.maxTempo andMin:_mainSequencer.minTempo]) {
        return;
    }

    [_mainSequencer setTempo:newTempoValue];
}

- (bool)isTextANumber: (NSString *)aString{
    NSCharacterSet *alphaNumbers = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:aString];
    return [alphaNumbers isSupersetOfSet:inStringSet];
}

- (bool)isValue: (NSInteger)aValue withingMax: (NSInteger)aMaximum andMin: (NSInteger)aMinimum{
    return aValue <= aMaximum && aValue >= aMinimum;
}

@end
