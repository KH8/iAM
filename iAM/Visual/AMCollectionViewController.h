//
//  AMCollectionViewController.h
//  iAM
//
//  Created by Krzysztof Reczek on 22.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMStave.h"
#import "AMNote.h"

@interface AMCollectionViewController : NSObject <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AMNoteDelegate>

@property AMStave *mainStave;

- (id)initWithCollectionView:(UICollectionView *)aCollectionView;
- (void)dealloc;

- (void)setLengthToBeDisplayed: (NSInteger)aLength;
- (void)reloadData;

@end
