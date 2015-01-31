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
    _lengthPickerController = nil;
    _tempoPickerController = nil;
}

- (IBAction)gesturePerformed:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion: nil];
}

- (void)pickerSelectionHasChanged{
    _lengthPicked = _lengthPickerController.getActualPickerValue;
    _tempoPicked = _tempoPickerController.getActualPickerValue;
    [_delegate valuesPickedLength:_lengthPicked andTempo:_tempoPicked];
}

@end
