//
//  AMPageContentViewController.h
//  iAM
//
//  Created by Krzysztof Reczek on 23.04.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMPageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property NSUInteger pageIndex;
@property NSString *imageFile;

@end
