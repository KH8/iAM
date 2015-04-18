//
//  AMPropertiesTableViewController.h
//  iAM
//
//  Created by Krzysztof Reczek on 05.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMConfirmationViewController.h"

@interface AMPropertiesTableViewController : UITableViewController <AMConfirmationViewControllerProtocol>

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideMenuButton;

@end
