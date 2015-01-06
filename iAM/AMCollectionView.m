//
//  AMCollectionViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 06.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMCollectionView.h"
#import "AMCollectionViewCell.h"

@interface AMCollectionView ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation AMCollectionView

- (void)loadInitialData
{
    AMCollectionViewCell *firstSection = [[AMCollectionViewCell alloc] init];
    AMCollectionViewCell *secondSection = [[AMCollectionViewCell alloc] init];
    
    self.items = [[NSArray alloc] initWithObjects:firstSection, secondSection, nil];
}

- (void)viewDidLoad
{
    [self loadInitialData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.items count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *sectionArray = [self.items objectAtIndex:section];
    return [sectionArray count]; }

@end
