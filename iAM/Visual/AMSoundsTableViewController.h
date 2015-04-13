//
//  AMSoundsTableViewController.h
//  iAM
//
//  Created by Krzysztof Reczek on 12.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMPlayer.h"

@interface AMSoundsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

- (void)assignPlayer:(AMPlayer*)player;

@end
