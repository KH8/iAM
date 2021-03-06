//
//  AMCollectionViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 22.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMCollectionViewController.h"
#import "AMCollectionViewCell.h"


@interface AMCollectionViewController ()

@property AMBar *actualBar;
@property AMStave *mainStave;
@property AMSequencer *mainSequencer;
@property UICollectionView *collectionView;

@end


@implementation AMCollectionViewController {
}

static NSString *const reuseIdentifier = @"myCell";

- (id)initWithCollectionView:(UICollectionView *)aCollectionView
                andSequencer:(AMSequencer *)aSequencer {
    self = [super init];
    if (self) {
        _collectionView = aCollectionView;
        _mainSequencer = aSequencer;
        [_mainSequencer addSequencerDelegate:self];
        [self updateComponents];
    }
    return self;
}

- (void)dealloc {
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self getNumberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self getNumberOfRows];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AMCollectionViewCell *newCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                              forIndexPath:indexPath];
    NSUInteger numberOfLine = (NSUInteger) [self getNumberOfLine:indexPath];
    AMMutableArray *lineOfNotes = (AMMutableArray *) [_actualBar getObjectAtIndex:numberOfLine];
    NSUInteger numberOfNote = (NSUInteger) [self getNumberOfNote:indexPath];
    [newCell setNoteAssigned:lineOfNotes[numberOfNote]];
    return newCell;
}

- (void)  collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AMCollectionViewCell *cell = (AMCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    [cell touch];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float cellSize = (float) ((_collectionView.bounds.size.height / 3.0) - 0.1);
    return CGSizeMake(cellSize, cellSize);
}

- (NSInteger)getNumberOfRows {
    return _actualBar.getNumberOfLines;
}

- (NSInteger)getNumberOfSections {
    return _actualBar.getLengthToBePlayed;
}

- (NSInteger)getNumberOfLine:(NSIndexPath *)indexPath {
    return indexPath.row;
}

- (NSInteger)getNumberOfNote:(NSIndexPath *)indexPath {
    NSInteger multiplier = (NSInteger) (4.0 / _actualBar.getDensity);
    return indexPath.section * multiplier;
}

- (void)signatureHasBeenChanged {
    [self reloadData];
}

- (void)arrayHasBeenChanged {

}

- (void)selectionHasBeenChanged {
    [self updateComponents];
    [self reloadData];
}

- (void)maxCountExceeded {

}

- (void)sequenceHasStarted {

}

- (void)sequenceHasStopped {

}

- (void)sequenceHasChanged {
    [self updateComponents];
    [self reloadData];
}

- (void)updateComponents {
    AMSequence *sequence = _mainSequencer.getSequence;
    [sequence addArrayDelegate:self];
    AMSequenceStep *sequenceStep = (AMSequenceStep *) sequence.getActualObject;
    _mainStave = sequenceStep.getStave;
    [_mainStave addArrayDelegate:self];
    _actualBar = (AMBar *) _mainStave.getActualObject;
    [_actualBar addBarDelegate:self];
}

- (void)reloadData {
    [_collectionView reloadData];
}

@end
