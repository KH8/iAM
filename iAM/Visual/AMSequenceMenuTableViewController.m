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
#import "AMCellShiftProvider.h"
#import "AMConfig.h"

@interface AMSequenceMenuTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;

@property AMMutableArray *arrayOfSequences;
@property AMSequencer *sequencer;

@property AMCellShiftProvider *cellShiftProvider;

@end

@implementation AMSequenceMenuTableViewController

static NSString *const reuseIdentifier = @"myMenuStepCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainObjects];
    [self loadCellShiftProvider];
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

- (void)loadCellShiftProvider {
    _cellShiftProvider = [[AMCellShiftProvider alloc] initWith:_arrayOfSequences
                                                    controller:self.tableView];
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
    [_cellShiftProvider performShifting:sender];
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
