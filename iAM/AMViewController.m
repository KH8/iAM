//
//  AMCollectionViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 06.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMViewController.h"
#import "AMCollectionViewCell.h"
#import "AMPoint.h"

@interface AMViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation AMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= 24; i++) {
        AMPoint *newPoint = [AMPoint alloc];
        newPoint.name = [NSString stringWithFormat:@"%d", i];
        [self.dataArray addObject:newPoint];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AMCollectionViewCell * newCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    newCell.myPoint = self.dataArray[indexPath.row];
    newCell.myLabel.text = newCell.myPoint.name;
    
    return newCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AMCollectionViewCell *cell = (AMCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    AMPoint *point = cell.myPoint;
    
    [point select];
    
    cell.backgroundColor = [UIColor lightGrayColor ];
    if(point.isSelected) cell.backgroundColor = [UIColor grayColor ];
}

@end
