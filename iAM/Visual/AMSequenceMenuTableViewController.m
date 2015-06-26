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
#import "AMVisualUtils.h"
#import "AMConfig.h"

@interface AMSequenceMenuTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;

@property UIBarButtonItem *tempDeleteButton;
@property UIBarButtonItem *tempAddButton;
@property UIBarButtonItem *tempDuplicateButton;

@property NSMutableArray *toolbarItemsArray;

@property AMMutableArray *arrayOfSequences;
@property AMSequencer *sequencer;
@property AMCellShiftProvider *cellShiftProvider;

@end

@implementation AMSequenceMenuTableViewController

static NSString *const reuseIdentifier = @"myMenuStepCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainObjects];
    [self initCellShiftProvider];
    [self initBottomToolBar];
    [self initTheme];
    [self initButtons];
    [self updateIndexSelected];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)initMainObjects {
    AMSequencerSingleton *sequencerSingleton = [AMSequencerSingleton sharedSequencer];
    _arrayOfSequences = sequencerSingleton.arrayOfSequences;
    [_arrayOfSequences addArrayDelegate:self];
    _sequencer = sequencerSingleton.sequencer;
}

- (void)initCellShiftProvider {
    _cellShiftProvider = [[AMCellShiftProvider alloc] initWith:_arrayOfSequences
                                                    controller:self.tableView];
}

- (void)initTheme {
    UIColor *globalColorTheme = [AMAppearanceManager getGlobalColorTheme];
    UIColor *globalTintColor = [AMAppearanceManager getGlobalTintColor];
    [_bottomToolBar setTintColor:globalTintColor];
    [_bottomToolBar setBarTintColor:globalColorTheme];
    [_navigationBar setTintColor:globalTintColor];
    [_navigationBar setBarTintColor:globalColorTheme];
}

- (void)initButtons {
    super.navigationBarItem.rightBarButtonItem = [AMVisualUtils createBarButton:@"grid.png"
                                          targer:self
                                        selector:@selector(onGridButtonPressedAction:)
                                            size:26];
}

- (void)initBottomToolBar {
    _toolbarItemsArray = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    [_toolbarItemsArray addObject:flexibleItem];
    [self showEditButtons];
    [AMVisualUtils applyObjectsToToolBar:_bottomToolBar
                             fromAnArray:_toolbarItemsArray];
}

- (void)showEditButtons{
    _tempAddButton = [AMVisualUtils createBarButton:@"add_r.png"
                                             targer:self
                                           selector:@selector(onAddAction:)
                                               size:30];
    _tempDeleteButton = [AMVisualUtils createBarButton:@"delete_r.png"
                                                targer:self
                                              selector:@selector(onDeleteAction:)
                                                  size:30];
    _tempDuplicateButton = [AMVisualUtils createBarButton:@"copy_r.png"
                                                   targer:self
                                                 selector:@selector(onDuplicateAction:)
                                                     size:30];
    [_toolbarItemsArray addObject:_tempDeleteButton];
    [_toolbarItemsArray addObject:_tempAddButton];
    [_toolbarItemsArray addObject:_tempDuplicateButton];
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
}

- (IBAction)onDeleteAction:(id)sender {
    [_arrayOfSequences removeActualObject];
}

- (IBAction)onDuplicateAction:(id)sender {
    [_arrayOfSequences duplicateObject];
}

- (IBAction)onLongPressAction:(id)sender {
    [_cellShiftProvider performShifting:sender];
}

- (IBAction)onGridButtonPressedAction:(id)sender {
    [self performSegueWithIdentifier:@"sw_grid" sender:self];
}

- (void)arrayHasBeenChanged {
    [self updateComponents];
}

- (void)selectionHasBeenChanged {
    [self updateComponents];
}

- (void)maxCountExceeded {
    [self performSegueWithIdentifier:@"sw_sequence_popup" sender:self];
}

- (void)updateComponents {
    AMSequence *sequenceSelected = (AMSequence *) _arrayOfSequences.getActualObject;
    [_sequencer setSequence:sequenceSelected];
    [_tableView reloadData];
    [self updateIndexSelected];
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
