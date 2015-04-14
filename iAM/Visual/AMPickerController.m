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

- (void)setDataArray: (NSArray*)anArray{
    pickerData = anArray;
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

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.text = [NSString stringWithFormat:@"%ld", (long)[pickerData[(NSUInteger) row] integerValue]];
    label.font = [UIFont systemFontOfSize:24];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [[UIView appearance] tintColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component{
    actualValue = pickerData[(NSUInteger) row];
    [_delegate pickerSelectionHasChanged];
}

- (NSInteger)getActualPickerValue{
    return [actualValue integerValue];
}

@end