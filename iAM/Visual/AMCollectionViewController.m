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

@property AMSequence *mainSequence;
@property UICollectionView *collectionView;

@end


@implementation AMCollectionViewController {
}

static NSString * const reuseIdentifier = @"myCell";

- (id)initWithCollectionView:(UICollectionView *)aCollectionView
                 andSequence: (AMSequence *)aSequence{
    self = [super init];
    if (self) {
        _collectionView = aCollectionView;
        _mainSequence = aSequence;
    }
    return self;
}

- (void)dealloc {
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _mainSequence.getNumberOfLines;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return _mainSequence.getLengthToBePlayed;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AMCollectionViewCell * newCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                               forIndexPath:indexPath];
    NSMutableArray * lineOfNotes = [_mainSequence getLine:(NSUInteger) indexPath.section];
    [newCell setNoteAssigned:lineOfNotes[(NSUInteger) indexPath.row]];
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


@end
