//
//  AMMenuTableViewController.h
//  iAM
//
//  Created by Krzysztof Reczek on 16.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMNavigationViewController.h"
#import "AMMutableArray.h"

@interface AMSequenceMenuTableViewController : AMNavigationViewController <UITableViewDataSource, UITableViewDelegate, AMMutableArrayDelegate>

@end
