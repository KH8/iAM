//
//  AMSequenceTableViewCell.h
//  iAM
//
//  Created by Krzysztof Reczek on 16.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMSequenceStep.h"
#import "AMPlayer.h"

@interface AMSoundTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *soundTitle;

- (void)assignPlayer:(AMPlayer*)player;

- (void)assignSoundKey: (NSString*)key;
- (void)assignSoundValue: (NSString*)value;
- (NSString*)getValue;

@end
