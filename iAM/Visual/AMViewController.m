//
//  AMCollectionViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 06.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMViewController.h"

@interface AMViewController ()

@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *lengthTextField;
@property (weak, nonatomic) IBOutlet UITextField *tempoTextField;

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

    _lengthTextField.text = [NSString stringWithFormat:@"%d", _mainSequencer.getLengthToBePlayed];
    _tempoTextField.text = [NSString stringWithFormat:@"%d", _mainSequencer.getTempo];
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

- (IBAction)lengthHasBeenChanged:(id)sender {
    NSInteger actualLengthValue = _mainSequencer.getLengthToBePlayed;
    NSInteger newLengthValue = [_lengthTextField.text integerValue];

    if (![self isTextANumber:_lengthTextField.text] || ![self isValue:newLengthValue withingMax:_mainSequencer.maxLength andMin:_mainSequencer.minLength]) {
        _lengthTextField.text = [NSString stringWithFormat:@"%d", actualLengthValue];
        return;
    }

    [_mainSequencer setLengthToBePlayed:newLengthValue];
    [_collectionView reloadData];
}

- (IBAction)tempoHasBeenChanged:(id)sender {
    NSInteger actualTempoValue = _mainSequencer.getTempo;
    NSInteger newTempoValue = [_tempoTextField.text integerValue];

    if (![self isTextANumber:_tempoTextField.text] || ![self isValue:newTempoValue withingMax:_mainSequencer.maxTempo andMin:_mainSequencer.minTempo]) {
        _tempoTextField.text = [NSString stringWithFormat:@"%d", actualTempoValue];
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

@end