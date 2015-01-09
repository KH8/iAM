//
//  AMCollectionViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 06.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMViewController.h"
#import "AMCollectionViewCell.h"

@interface AMViewController ()

@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation AMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainStave = [[AMStave alloc] init];
    [self.mainStave configureCustomWithNumberOfLines:[NSNumber numberWithInt:3] numberOfNotesPerLine:[NSNumber numberWithInt:10]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.mainStave.count;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray * lineOfNotes = self.mainStave[section];
    return lineOfNotes.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AMCollectionViewCell * newCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    NSMutableArray * lineOfNotes = self.mainStave[indexPath.section];
    newCell.noteAssigned = lineOfNotes[indexPath.row];
    newCell.titleLabel.text = [NSString stringWithFormat:@"%@", newCell.noteAssigned.id];
    
    newCell.backgroundColor = [UIColor lightGrayColor ];
    if(newCell.noteAssigned.isSelected) newCell.backgroundColor = [UIColor grayColor ];
    
    return newCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AMCollectionViewCell *cell = (AMCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    AMNote *note = cell.noteAssigned;
    
    [note select];
    NSArray *arrayOfPaths = @[indexPath];
    [self.collectionView reloadItemsAtIndexPaths:arrayOfPaths];
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
    [self.mainStave clear];
    [self.collectionView reloadData];
}

@end
