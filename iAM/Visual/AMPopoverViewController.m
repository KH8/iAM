//
//  AMPopoverViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 31.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMPopoverViewController.h"

@interface AMPopoverViewController ()

@property NSNumber *lengthPicked;
@property NSNumber *tempoPicked;

@end

@implementation AMPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPickers];
}

- (void)loadPickers{
    AMStave *stave = _actuallySelectedSequencer.getStave;
    AMBar *bar = stave.getActualBar;
    NSArray *sinatureNumeratorPickerData = [self createRangeOfValuesStartingFrom:bar.minSignature
                                                                            upTo:bar.getSignatureNumerator];
    _signatureNumeratorPickerController = [[AMPickerController alloc] initWithPicker:_signatureNumeratorPicker
                                                                           dataArray:sinatureNumeratorPickerData
                                                                       andStartValue:@(bar.getSignatureNumerator)];
    _signatureNumeratorPickerController.delegate = self;
    
    NSArray *sinatureDenominatorPickerData = [self createRangeOfValuesStartingFrom:bar.minSignature
                                                                              upTo:bar.maxSignature];
    _signatureDenominatorPickerController = [[AMPickerController alloc] initWithPicker:_signatureDenominatorPicker
                                                                             dataArray:sinatureDenominatorPickerData
                                                                         andStartValue:@(bar.getSignatureDenominator)];
    _signatureDenominatorPickerController.delegate = self;
    
    NSArray *tempoPickerData = [self createRangeOfValuesStartingFrom:stave.minTempo
                                                                upTo:stave.maxTempo];
    _tempoPickerController = [[AMPickerController alloc] initWithPicker:_tempoPicker
                                                              dataArray:tempoPickerData
                                                          andStartValue:@(stave.getTempo)];
    _tempoPickerController.delegate = self;
    
    NSArray *sizePickerData = [self createRangeOfValuesStartingFrom:bar.minLength
                                                               upTo:bar.maxLength];
    _lengthPickerController = [[AMPickerController alloc] initWithPicker:_lengthPicker
                                                               dataArray:sizePickerData
                                                           andStartValue:@(bar.getLengthToBePlayed)];
    _lengthPickerController.delegate = self;
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
    _lengthPickerController = nil;
    _tempoPickerController = nil;
}

- (IBAction)gesturePerformed:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion: nil];
}

- (void)pickerSelectionHasChanged{
    AMStave *stave = _actuallySelectedSequencer.getStave;
    AMBar *bar = stave.getActualBar;
    NSArray *sinatureNumeratorPickerData = [self createRangeOfValuesStartingFrom:bar.minSignature
                                                                            upTo:bar.getSignatureNumerator];
    [_signatureNumeratorPickerController setDataArray:sinatureNumeratorPickerData];
    [_signatureNumeratorPicker reloadAllComponents];
    _lengthPicked = _lengthPickerController.getActualPickerValue;
    _tempoPicked = _tempoPickerController.getActualPickerValue;
    [_delegate valuesPickedLength:_lengthPicked andTempo:_tempoPicked];
}

@end
