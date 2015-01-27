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
#import "AMSequencer.h"
#import "AMNote.h"

@interface AMViewController : UIViewController <AMPickerControllerDelegate, AMSequencerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPickerView *lengthPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *tempoPicker;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end
