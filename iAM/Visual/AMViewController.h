//
//  AMCollectionViewController.h
//  iAM
//
//  Created by Krzysztof Reczek on 06.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMCollectionViewController.h"
#import "AMPickerController.h"
#import "AMPopoverViewController.h"
#import "AMSequencer.h"
#import "AMNote.h"

@interface AMViewController : UIViewController <AMSequencerDelegate, AMStaveVisualDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideMenuButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *listButton;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;

@end
