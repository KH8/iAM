//
//  AMCellShiftProvider.m
//  iAM
//
//  Created by Krzysztof Reczek on 24.06.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMCellShiftProvider.h"

@interface AMCellShiftProvider () {
}

@property AMMutableArray *array;
@property UITableView *tableView;

@end

@implementation AMCellShiftProvider

- (id)initWith:(AMMutableArray *)array
    controller:(UITableView *)tableView {
    self = [super init];
    if (self) {
        _array = array;
        _tableView = tableView;
    }
    return self;
}

- (void)performShifting:(id)sender {
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *) sender;
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];

    static UIView *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath *sourceIndexPath = nil; ///< Initial index path, where gesture begins.

    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;

                UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];

                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];

                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [_tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{

                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(0.98, 0.98);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;

                }                completion:^(BOOL finished) {

                    cell.hidden = YES;

                }];
            }
            break;
        }

        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;

            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {

                // ... update data source.
                [_array exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];

                // ... move the rows.
                [_tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];

                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }

        default: {
            // Clean up.
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;

            [UIView animateWithDuration:0.25 animations:^{

                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;

            }                completion:^(BOOL finished) {

                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;

            }];

            break;
        }
    }
}

- (UIView *)customSnapshoFromView:(UIView *)inputView {

    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;

    return snapshot;
}

@end
