//
// Created by Krzysztof Reczek on 23.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMPickerController.h"


@implementation AMPickerController {
    NSArray *pickerData;
    NSString *actualValue;
}

- (id)initWithDataArray:(NSArray *)anArray {
    self = [super init];
    if (self) {
        pickerData = anArray;
        actualValue = pickerData[0];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    actualValue = pickerData[row];
    [_delegate pickerSelectionHasChanged];
}

- (NSString*)getActualPickerValue{
    return actualValue;
}

@end