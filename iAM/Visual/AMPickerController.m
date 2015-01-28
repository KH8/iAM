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
    NSNumber *actualValue;
}

- (id)initWithPicker: (UIPickerView *)aPicker
           dataArray: (NSArray *)anArray
       andStartValue: (NSNumber*)newValue{
    self = [super init];
    if (self) {
        _picker = aPicker;
        _picker.delegate = self;
        _picker.dataSource = self;
        pickerData = anArray;
        [self setActualValue:newValue];
    }
    return self;
}

- (void)setActualValue: (NSNumber*)newValue{
    for (NSNumber *data in pickerData) {
        if([data isEqualToNumber:newValue]){
            NSInteger anIndex=[pickerData indexOfObject:data];
            actualValue = pickerData[(NSUInteger) anIndex];
            [_picker selectRow:anIndex inComponent:0 animated:NO];
        }
    }
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
    return [NSString stringWithFormat:@"%ld", (long)[pickerData[(NSUInteger) row] integerValue]];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component{
    actualValue = pickerData[(NSUInteger) row];
    [_delegate pickerSelectionHasChanged];
}

- (NSNumber*)getActualPickerValue{
    return actualValue;
}

@end