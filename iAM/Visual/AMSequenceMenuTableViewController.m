//
//  AMMenuTableViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 16.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequenceMenuTableViewController.h"
#import "AMSequenceMenuTableViewCell.h"
#import "AMSequencerSingleton.h"
#import "AMPopupViewController.h"
#import "AMAppearanceManager.h"
#import "AMConfig.h"

@interface AMSequenceMenuTableViewController ()

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;

@property AMMutableArray *arrayOfSequences;
@property AMSequencer *sequencer;

@end

@implementation AMSequenceMenuTableViewController

static NSString *const reuseIdentifier = @"myMenuStepCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainObjects];
    [self updateIndexSelected];
    [self loadTheme];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)loadMainObjects {
    AMSequencerSingleton *sequencerSingleton = [AMSequencerSingleton sharedSequencer];
    _arrayOfSequences = sequencerSingleton.arrayOfSequences;
    [_arrayOfSequences addArrayDelegate:self];
    _sequencer = sequencerSingleton.sequencer;
}

- (void)loadTheme {
    UIColor *globalColorTheme = [AMAppearanceManager getGlobalColorTheme];
    UIColor *globalTintColor = [AMAppearanceManager getGlobalTintColor];
    [_bottomToolBar setTintColor:globalTintColor];
    [_bottomToolBar setBarTintColor:globalColorTheme];
    [_navigationBar setTintColor:globalTintColor];
    [_navigationBar setBarTintColor:globalColorTheme];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [_arrayOfSequences count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMSequence *sequence = _arrayOfSequences[(NSUInteger) indexPath.row];
    AMSequenceMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier
                                                                        forIndexPath:indexPath];
    [cell assignSequence:sequence];
    if (indexPath.row == 0) {
        cell.textLabel.textColor = [[UIView appearance] tintColor];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_arrayOfSequences setIndexAsActual:indexPath.row];
    [self updateComponents];
}

- (IBAction)onAddAction:(id)sender {
    AMSequence *newSequence = [[AMSequence alloc] initWithSubComponents];
    [_arrayOfSequences addObject:newSequence];
    [_tableView reloadData];
    [self updateIndexSelected];
}

- (IBAction)onDeleteAction:(id)sender {
    [_arrayOfSequences removeActualObject];
    [_tableView reloadData];
    [self updateIndexSelected];
    [self updateComponents];
}

- (IBAction)onDuplicateAction:(id)sender {
    [_arrayOfSequences duplicateObject];
    [_tableView reloadData];
    [self updateIndexSelected];
    [self updateComponents];
}

- (IBAction)onLongPressAction:(id)sender {
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
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
                [_arrayOfSequences exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
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

- (void)arrayHasBeenChanged {
}

- (void)selectionHasBeenChanged {
}

- (void)maxCountExceeded {
    [self performSegueWithIdentifier:@"sw_sequence_popup" sender:self];
}

- (void)updateComponents {
    AMSequence *sequenceSelected = (AMSequence *) _arrayOfSequences.getActualObject;
    [_sequencer setSequence:sequenceSelected];
}

- (void)updateIndexSelected {
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_arrayOfSequences.getActualIndex
                                                            inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"sw_sequence_popup"]) {
        AMPopupViewController *popupViewController = (AMPopupViewController *) segue.destinationViewController;
        [popupViewController setText:[AMConfig sequenceCountExceeded]];
    }
}

@end
