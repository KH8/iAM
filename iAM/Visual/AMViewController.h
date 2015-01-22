//
//  AMCollectionViewController.h
//  iAM
//
//  Created by Krzysztof Reczek on 06.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMSequencer.h"
#import "AMCollectionViewCell.h"

@interface AMViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AMSequencerDelegate, AMNoteDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) AMSequencer *mainSequencer;

@property (weak, nonatomic) IBOutlet UIPickerView *sizePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *tempoPicker;

- (void) sequencerHasStarted;
- (void) sequencerHasStopped;

- (void) noteHasBeenTriggered;

@end
