//
//  AMSequenceTableViewCell.h
//  iAM
//
//  Created by Krzysztof Reczek on 16.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMSequenceStep.h"
#import "Primitives/AMTableViewCell.h"

@interface AMSequenceTableViewCell : AMTableViewCell

@property(weak, nonatomic) IBOutlet UITextField *stepTitle;
@property(weak, nonatomic) IBOutlet UILabel *stepSubtitle;

- (void)assignSequenceStep:(AMSequenceStep *)aStep;

@end
