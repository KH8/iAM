//
//  AMNavigationViewController.h
//  iAM
//
//  Created by Krzysztof Reczek on 28.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMNavigationViewController : UIViewController

@property(weak, nonatomic) IBOutlet UINavigationItem *navigationBarItem;
@property(strong, nonatomic) IBOutlet UIBarButtonItem *sideMenuButton;

@end
