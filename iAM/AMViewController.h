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

@interface AMViewController : UIViewController <SequencerDelegate, NoteDelegate>

@property (strong, nonatomic) AMSequencer *mainSequencer;

- (void) sequencerHasStarted;
- (void) sequencerHasStopped;

- (void) noteHasBeenTriggered;

@end
