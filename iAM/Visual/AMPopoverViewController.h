//
//  AMPopoverViewController.h
//  iAM
//
//  Created by Krzysztof Reczek on 31.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMPickerController.h"
#import "AMSequencer.h"

@protocol AMPopoverViewControllerDelegate <NSObject>

@required

- (void) valuesPickedLength:(NSNumber *)lengthPicked andTempo:(NSNumber *)tempoPicked;

@end

@interface AMPopoverViewController : UIViewController <AMPickerControllerDelegate>
{
    // Delegate to respond back
    id <AMPopoverViewControllerDelegate> _delegate;
    
}

@property (nonatomic,strong) id delegate;
@property AMPickerController *lengthPickerController;
@property AMPickerController *tempoPickerController;
@property (weak, nonatomic) IBOutlet UIPickerView *lengthPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *tempoPicker;
@property AMSequencer *actuallySelectedSequencer;

@end
