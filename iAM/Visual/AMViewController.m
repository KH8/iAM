//
//  AMCollectionViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 06.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMViewController.h"
#import "AMStave.h"

@interface AMViewController () {
    NSArray *sizePickerData;
    NSArray *tempoPickerData;
}

@property AMCollectionViewController *collectionViewController;

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
    
    sizePickerData = @[@"3",@"4",@"6",@"8",@"9",@"12",@"16"];
    tempoPickerData = @[@"60",@"100",@"140",@"180",@"220",@"260",@"300"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    [_mainSequencer killBackgroundThread];
    _mainSequencer = nil;
}

- (IBAction)onTouchEvent:(id)sender {
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


- (void)lengthHasBeenChanged:(NSString*)lengthText {
    NSInteger newLengthValue = [lengthText integerValue];

    if (![self isTextANumber:lengthText] || ![self isValue:newLengthValue withingMax:_mainSequencer.maxLength andMin:_mainSequencer.minLength]) {
        return;
    }

    [_mainSequencer setLengthToBePlayed:newLengthValue];
    [_collectionViewController reloadData];
}

- (void)tempoHasBeenChanged:(NSString*)tempoText {
    NSInteger newTempoValue = [tempoText integerValue];

    if (![self isTextANumber:tempoText] || ![self isValue:newTempoValue withingMax:_mainSequencer.maxTempo andMin:_mainSequencer.minTempo]) {
        return;
    }

    [_mainSequencer setTempo:newTempoValue];
    [_collectionView reloadData];
}

- (bool)isTextANumber: (NSString *)aString{
    NSCharacterSet *alphaNumbers = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:aString];
    return [alphaNumbers isSupersetOfSet:inStringSet];
}

- (bool)isValue: (NSInteger)aValue withingMax: (NSInteger)aMaximum andMin: (NSInteger)aMinimum{
    return aValue <= aMaximum && aValue >= aMinimum;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == _sizePicker){
        return sizePickerData.count;
    }
    if(pickerView == _tempoPicker){
        return tempoPickerData.count;
    }
    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == _sizePicker){
        return sizePickerData[row];
    }
    if(pickerView == _tempoPicker){
        return tempoPickerData[row];
    }
    return @"";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == _sizePicker){
        NSString *valueSelected = sizePickerData[row];
        [self lengthHasBeenChanged:valueSelected];
    }
    if(pickerView == _tempoPicker){
        NSString *valueSelected = tempoPickerData[row];
        [self tempoHasBeenChanged:valueSelected];
    }
}

@end
