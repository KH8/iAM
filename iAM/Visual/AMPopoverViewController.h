//
//  AMPopoverViewController.h
//  iAM
//
//  Created by Krzysztof Reczek on 31.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMPickerController.h"
#import "AMVisualEffectView.h"
#import "AMSequencer.h"
#import "AMOverlayViewController.h"

@protocol AMPopoverViewControllerDelegate <NSObject>

@required

- (void)pickedValuesHaveBeenChanged;

@end

@interface AMPopoverViewController : AMOverlayViewController <AMPickerControllerDelegate, AMStaveDelegate>

@property(nonatomic, weak) id <AMPopoverViewControllerDelegate> delegate;

@property AMPickerController *signatureNumeratorPickerController;
@property AMPickerController *signatureDenominatorPickerController;
@property AMPickerController *densityPickerController;
@property AMPickerController *tempoPickerController;
@property(weak, nonatomic) IBOutlet UIPickerView *signatureNumeratorPicker;
@property(weak, nonatomic) IBOutlet UIPickerView *signatureDenominatorPicker;
@property(weak, nonatomic) IBOutlet UIPickerView *densityPicker;
@property(weak, nonatomic) IBOutlet UIPickerView *tempoPicker;
@property AMSequencer *actuallySelectedSequencer;

@end
