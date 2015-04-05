//
//  AMMenuTableViewCell.h
//  iAM
//
//  Created by Krzysztof Reczek on 22.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMSequence.h"

@interface AMSequenceMenuTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

- (void)assignSequence: (AMSequence*)aSequence;

@end
