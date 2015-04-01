//
//  AMPopoverViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 31.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMPopoverViewController.h"

@interface AMPopoverViewController ()

@end

@implementation AMPopoverViewController{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPickers];
}

- (void)loadPickers{
    AMStave *stave = _actuallySelectedSequencer.getStave;
    stave.delegate = self;
    AMBar *bar = (AMBar *)stave.getActualObject;
    NSArray *signatureNumeratorPickerData = [self createRangeOfValuesStartingFrom:bar.minSignature
                                                                            upTo:bar.getSignatureDenominator];
    _signatureNumeratorPickerController = [[AMPickerController alloc] initWithPicker:_signatureNumeratorPicker
                                                                           dataArray:signatureNumeratorPickerData
                                                                       andStartValue:@(bar.getSignatureNumerator)];
    _signatureNumeratorPickerController.delegate = self;
    
    NSArray *sinatureDenominatorPickerData = @[@1, @2, @4, @8, @16, @32];
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
    
    NSArray *densityPickerData = @[@1, @2, @4];
    _densityPickerController = [[AMPickerController alloc] initWithPicker:_densityPicker
                                                               dataArray:densityPickerData
                                                           andStartValue:@(bar.getDensity)];
    _densityPickerController.delegate = self;
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
    _densityPickerController = nil;
    _tempoPickerController = nil;
}

- (IBAction)gesturePerformed:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion: nil];
}

- (IBAction)onTapTempo:(id)sender {
    AMStave *stave = _actuallySelectedSequencer.getStave;
    [stave tapTempo];
}

- (void)pickerSelectionHasChanged{
    AMStave *stave = _actuallySelectedSequencer.getStave;
    [self tempoHasBeenChanged:stave];
    AMBar *bar = (AMBar *)stave.getActualObject;
    [self signatureDenominatorHasBeenChanged:bar];
    [self signatureNumeratorHasBeenChanged:bar];
    [self densityHasBeenChanged:bar];
    [_delegate pickedValuesHaveBeenChanged];
}

- (void)signatureNumeratorHasBeenChanged:(AMBar*)bar {
    NSInteger valuePicked = [_signatureNumeratorPickerController getActualPickerValue];
    NSInteger newSignatureDenominator = [_signatureDenominatorPickerController getActualPickerValue];
    if(valuePicked > newSignatureDenominator){
        valuePicked = newSignatureDenominator;
    }
    if([bar getSignatureNumerator] == valuePicked) return;
    [bar setSignatureNumerator:valuePicked];
}

- (void)signatureDenominatorHasBeenChanged:(AMBar*)bar {
    NSInteger valuePicked = [_signatureDenominatorPickerController getActualPickerValue];
    if([bar getSignatureDenominator] == valuePicked) return;
    [bar setSignatureDenominator:valuePicked];
    NSArray *signatureNumeratorPickerData = [self createRangeOfValuesStartingFrom:bar.minSignature
                                                                            upTo:bar.getSignatureDenominator];
    [_signatureNumeratorPickerController setDataArray:signatureNumeratorPickerData];
    [_signatureNumeratorPicker reloadAllComponents];
}

- (void)densityHasBeenChanged:(AMBar*)bar {
    NSInteger valuePicked = [_densityPickerController getActualPickerValue];
    if([bar getDensity] == valuePicked) return;
    [bar setDensity:valuePicked];
}

- (void)tempoHasBeenChanged:(AMStave*)stave {
    NSInteger valuePicked = [_tempoPickerController getActualPickerValue];
    if([stave getTempo] == valuePicked) return;
    [stave setTempo:valuePicked];
}

- (void)tempoHasBeenChanged{
    AMStave *stave = _actuallySelectedSequencer.getStave;
    NSNumber *newTempo = [[NSNumber alloc] initWithInteger:stave.getTempo];
    [_tempoPickerController setActualValue:newTempo];
    [_delegate pickedValuesHaveBeenChanged];
}

@end
