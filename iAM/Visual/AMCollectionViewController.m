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

@end

@implementation AMCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainStave = [[AMStave alloc] init];
    [_mainStave configureDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    _mainStave = nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _mainStave.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
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
    //NSArray *arrayOfPaths = @[indexPath];
    //[self reloadItemsAtIndexPaths:arrayOfPaths];
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

@end
