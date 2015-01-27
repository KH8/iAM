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

- (void)loadMainObjects{
    _mainSequence = [[AMSequence alloc] init];
    _mainSequence.sequenceViewDelegate = self;
}

- (void)loadCollectionViewController{
    _collectionViewController = [[AMCollectionViewController alloc] initWithCollectionView:_collectionView
                                                                               andSequence:_mainSequence];
    _collectionView.delegate = _collectionViewController;
    _collectionView.dataSource = _collectionViewController;
}

- (void)loadPickers{
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
