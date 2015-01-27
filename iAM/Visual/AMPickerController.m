//
// Created by Krzysztof Reczek on 23.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMPickerController.h"

@interface AMPickerController ()

@property UIPickerView *picker;

@end


@implementation AMPickerController {
    NSArray *pickerData;
    NSString *actualValue;
}

- (id)initWithPicker:(UIPickerView *)aPicker
           dataArray:(NSArray *)anArray
       andStartIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        _picker = aPicker;
        _picker.delegate = self;
        _picker.dataSource = self;
        pickerData = anArray;
        actualValue = pickerData[index];
        [_picker selectRow:index inComponent:0 animated:NO];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return pickerData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component {
    return pickerData[(NSUInteger) row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component{
    actualValue = pickerData[(NSUInteger) row];
    [_delegate pickerSelectionHasChanged];
}

- (NSString*)getActualPickerValue{
    return actualValue;
}

@end