//
//  AMSequenceTableController.h
//  iAM
//
//  Created by Krzysztof Reczek on 16.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMSequence.h"
#import "AMSequencer.h"
#import "AMSequenceStep.h"

@interface AMSequenceTableController : UIViewController <UITableViewDataSource, UITableViewDelegate, AMSequencerDelegate, AMSequenceStepDelegate, AMStaveDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;

@end
