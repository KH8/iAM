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

@property UICollectionView *collectionView;

@end

@implementation AMCollectionViewController {
    NSInteger lengthToBeDisplayed;
}

static NSString * const reuseIdentifier = @"myCell";

- (id)initWithCollectionView:(UICollectionView *)aCollectionView {
    self = [super init];
    if (self) {
        _collectionView = aCollectionView;

        _mainStave = [[AMStave alloc] init];
        [_mainStave configureDefault];

        _mainSequencer = [[AMSequence alloc] init];
        [_mainSequencer initializeWithStave:_mainStave];
        _mainSequencer.delegate = self;

        lengthToBeDisplayed = 8;
    }
    return self;
}

- (void)dealloc {
    _mainStave = nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _mainStave.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return lengthToBeDisplayed;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AMCollectionViewCell * newCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                               forIndexPath:indexPath];
    NSMutableArray * lineOfNotes = _mainStave[(NSUInteger) indexPath.section];
    newCell.noteAssigned = lineOfNotes[(NSUInteger) indexPath.row];
    
    UIColor *color = [[UIColor lightGrayColor] colorWithAlphaComponent:0.9F];
    if(newCell.noteAssigned.isSelected) color = [[UIColor grayColor] colorWithAlphaComponent:0.9F];
    if(newCell.noteAssigned.isPlaying) color = [[UIColor greenColor] colorWithAlphaComponent:0.9F];
    if(newCell.noteAssigned.isTriggered) color = [color colorWithAlphaComponent:0.5F];
    
    newCell.backgroundColor = color;
    
    return newCell;
}

- (void)collectionView:(UICollectionView *)collectionView
        didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AMCollectionViewCell *cell = (AMCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    AMNote *note = cell.noteAssigned;
    
    [note select];
    NSArray *arrayOfPaths = @[indexPath];
    [_collectionView reloadItemsAtIndexPaths:arrayOfPaths];
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

- (void)rowHasBeenTriggered:(NSInteger)row {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:row inSection: 0];
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:row inSection: 1];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:row inSection: 2];
        NSArray *arrayOfPaths = @[indexPath0, indexPath1, indexPath2];
        [_collectionView reloadItemsAtIndexPaths:arrayOfPaths];
    });
}

- (void)setLengthToBeDisplayed: (NSInteger)aLength{
    lengthToBeDisplayed = aLength;
    [self reloadData];
}

- (void)reloadData {
    [_collectionView reloadData];
}


@end
