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

- (void) pickedValuesHaveBeenChanged;

@end

@interface AMPopoverViewController : UIViewController <AMPickerControllerDelegate>

@property (nonatomic, weak) id <AMPopoverViewControllerDelegate> delegate;

@property AMPickerController *signatureNumeratorPickerController;
@property AMPickerController *signatureDenominatorPickerController;
@property AMPickerController *lengthPickerController;
@property AMPickerController *tempoPickerController;
@property (weak, nonatomic) IBOutlet UIPickerView *signatureNumeratorPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *signatureDenominatorPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *lengthPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *tempoPicker;
@property AMSequencer *actuallySelectedSequencer;

@end
