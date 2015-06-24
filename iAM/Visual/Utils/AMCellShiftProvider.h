//
//  AMCellShiftProvider.h
//  iAM
//
//  Created by Krzysztof Reczek on 24.06.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AMMutableArray.h"

@interface AMCellShiftProvider : NSObject

- (id)initWith:(AMMutableArray *)array
    controller:(UITableView *)tableView;
- (void)performShifting:(id)sender;

@end
