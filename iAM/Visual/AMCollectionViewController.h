//
//  AMCollectionViewController.h
//  iAM
//
//  Created by Krzysztof Reczek on 22.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMStave.h"
#import "AMSequence.h"
#import "AMNote.h"

@interface AMCollectionViewController : NSObject <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AMSequenceDelegate>

- (id)initWithCollectionView:(UICollectionView *)aCollectionView
                 andSequence: (AMSequence *)aSequence;
- (void)dealloc;
- (void)reloadData;

@end
