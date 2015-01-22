//
//  AMCollectionViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 06.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMViewController.h"

@interface AMViewController () {
    NSArray *sizePickerData;
    NSArray *tempoPickerData;
}

@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property AMStave *mainStave;

@end

@implementation AMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mainStave = [[AMStave alloc] init];
    [_mainStave configureDefault];
    _mainSequencer = [[AMSequencer alloc] init];
    [_mainSequencer initializeWithStave:_mainStave];
    _mainSequencer.delegate = self;
    
    sizePickerData = @[@"3",@"4",@"6",@"8",@"9",@"12",@"16"];
    tempoPickerData = @[@"60",@"100",@"140",@"180",@"220",@"260",@"300"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    _mainStave = nil;

    [_mainSequencer killBackgroundThread];
    _mainSequencer = nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _mainStave.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _mainSequencer.getLengthToBePlayed;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AMCollectionViewCell * newCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    NSMutableArray * lineOfNotes = _mainStave[(NSUInteger) indexPath.section];
    newCell.noteAssigned = lineOfNotes[(NSUInteger) indexPath.row];
    newCell.noteAssigned.delegate = self;

    UIColor *color = [[UIColor lightGrayColor] colorWithAlphaComponent:0.9F];
    if(newCell.noteAssigned.isSelected) color = [[UIColor grayColor] colorWithAlphaComponent:0.9F];
    if(newCell.noteAssigned.isPlaying) color = [[UIColor greenColor] colorWithAlphaComponent:0.9F];
    if(newCell.noteAssigned.isTriggered) color = [color colorWithAlphaComponent:0.5F];

    newCell.backgroundColor = color;

    return newCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AMCollectionViewCell *cell = (AMCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    AMNote *note = cell.noteAssigned;
    
    [note select];
    NSArray *arrayOfPaths = @[indexPath];
    [_collectionView reloadItemsAtIndexPaths:arrayOfPaths];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}

- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1,1,1,1);
}

- (IBAction)onTouchEvent:(id)sender {
    [_mainStave clear];
    [_collectionView reloadData];
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

- (void)noteHasBeenTriggered {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_collectionView reloadData];
    });
}

- (void)lengthHasBeenChanged:(NSString*)lengthText {
    NSInteger newLengthValue = [lengthText integerValue];

    if (![self isTextANumber:lengthText] || ![self isValue:newLengthValue withingMax:_mainSequencer.maxLength andMin:_mainSequencer.minLength]) {
        return;
    }

    [_mainSequencer setLengthToBePlayed:newLengthValue];
    [_collectionView reloadData];
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
