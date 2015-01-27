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

@property AMSequencer *mainSequencer;
@property UICollectionView *collectionView;

@end


@implementation AMCollectionViewController {
}

static NSString * const reuseIdentifier = @"myCell";

- (id)initWithCollectionView:(UICollectionView *)aCollectionView
                andSequencer: (AMSequencer *)aSequencer {
    self = [super init];
    if (self) {
        _collectionView = aCollectionView;
        _mainSequencer = aSequencer;
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

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AMCollectionViewCell * newCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                               forIndexPath:indexPath];
    NSUInteger numberOfLine = (NSUInteger) [self getNumberOfLine:indexPath];
    NSMutableArray * lineOfNotes = [_mainSequencer getLine: numberOfLine];
    NSUInteger numberOfNote = (NSUInteger) [self getNumberOfNote:indexPath];
    [newCell setNoteAssigned:lineOfNotes[numberOfNote]];
    return newCell;
}

- (void)collectionView:(UICollectionView *)collectionView
        didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AMCollectionViewCell *cell = (AMCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    [cell touch];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
        minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
        minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}

- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1,1,1,1);
}

- (void)reloadData {
    [_collectionView reloadData];
}

- (NSInteger)getNumberOfRows {
    return _mainSequencer.getNumberOfLines;
}

- (NSInteger)getNumberOfSections {
    return _mainSequencer.getLengthToBePlayed;
}

- (NSInteger)getNumberOfLine: (NSIndexPath *)indexPath {
    return indexPath.row;
}

- (NSInteger)getNumberOfNote: (NSIndexPath *)indexPath {
    return indexPath.section;
}

@end
