//
// Created by Krzysztof Reczek on 23.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMPickerControllerDelegate <NSObject>

@required

- (void) pickerSelectionHasChanged;

@end

@interface AMPickerController : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>
{
    // Delegate to respond back
    id <AMPickerControllerDelegate> _delegate;

}

@property (nonatomic,strong) id delegate;

-(id)initWithPicker: (UIPickerView *)aPicker
          dataArray: (NSArray*)anArray
      andStartIndex:(NSInteger)index;
-(NSString*)getActualPickerValue;

@end