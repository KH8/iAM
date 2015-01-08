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
    
    for (int i = 1; i <= 3; i++) {
        NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
        [self.dataArray addObject: sectionArray];
        for (int j = 1; j <= 3; j++) {
            AMPoint *newPoint = [AMPoint alloc];
            newPoint.name = [NSString stringWithFormat:@"%d", i*10+j];
            [sectionArray addObject:newPoint];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray * sectionArray = self.dataArray[section];
    return sectionArray.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AMCollectionViewCell * newCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    NSMutableArray * sectionArray = self.dataArray[indexPath.section];
    newCell.myPoint = sectionArray[indexPath.row];
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
