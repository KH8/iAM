//
//  AMCollectionViewController.h
//  iAM
//
//  Created by Krzysztof Reczek on 22.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMBar.h"
#import "AMSequencer.h"
#import "AMNote.h"

@interface AMCollectionViewController : NSObject <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

- (id)initWithCollectionView:(UICollectionView *)aCollectionView
                andSequencer: (AMSequencer *)aSequencer;
- (void)changeSequencerAssigned: (AMSequencer *)aSequencer;

- (void)dealloc;
- (void)reloadData;

@end
