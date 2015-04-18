//
//  AMConfirmationViewController.h
//  iAM
//
//  Created by Krzysztof Reczek on 18.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMConfirmationViewControllerProtocol <NSObject>

@required

- (void)refreshView;

@end

@interface AMConfirmationViewController : UIViewController

@property (nonatomic, weak) id <AMConfirmationViewControllerProtocol> delegate;

@end
