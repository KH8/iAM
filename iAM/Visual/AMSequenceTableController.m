//
//  AMSequenceTableController.m
//  iAM
//
//  Created by Krzysztof Reczek on 16.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequenceTableController.h"
#import "AMSequenceTableViewCell.h"
#import "AMSequencerSingleton.h"
#import "AMPopupViewController.h"
#import "AMMutableArrayResponder.h"
#import "AMVisualUtils.h"
#import "AMCellShiftProvider.h"
#import "AMAppearanceManager.h"
#import "AMConfig.h"

@interface AMSequenceTableController ()

@property AMSequencer *mainSequencer;
@property AMSequence *mainSequence;

@property AMMutableArrayResponder *mainSequenceArrayResponder;
@property AMMutableArrayResponder *mainStaveArrayResponder;
@property AMCellShiftProvider *cellShiftProvider;

@property(weak, nonatomic) IBOutlet UITableView *tableView;

@property UIBarButtonItem *tempDeleteButton;
@property UIBarButtonItem *tempAddButton;
@property UIBarButtonItem *tempDuplicateButton;
@property UIBarButtonItem *tempEditButton;
@property UIBarButtonItem *tempLoopCountButton;
@property UIBarButtonItem *tempIncrementButton;
@property UIBarButtonItem *tempDecrementButton;

@property BOOL isEditEnabled;
@property BOOL isLoopCountEditEnabled;
@property NSMutableArray *toolbarItemsArray;

@end

@implementation AMSequenceTableController

static NSString *const reuseIdentifier = @"mySequenceStepCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _isEditEnabled = NO;
    
    [self initResponders];
    [self initSequence];
    [self initCellShiftProvider];
    [self initBottomToolBar];
    [self stepLoopCounterUpdate];
    [self updateComponents];
    [self updateIndexSelected];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initTheme];
}

- (void)initResponders {
    _mainSequenceArrayResponder = [[AMMutableArrayResponder alloc] initWithArrayHasChangedAction:@selector(sequenceArrayHasBeenChanged)
                                                                    andSelectionHasChangedAction:@selector(sequenceSelectionHasBeenChanged)
                                                                       andMaxCountExceededAction:@selector(sequenceMaxCountExceeded)
                                                                                       andTarget:self];
    _mainStaveArrayResponder = [[AMMutableArrayResponder alloc] initWithArrayHasChangedAction:@selector(staveArrayHasBeenChanged)
                                                                 andSelectionHasChangedAction:@selector(staveSelectionHasBeenChanged)
                                                                    andMaxCountExceededAction:@selector(staveMaxCountExceeded)
                                                                                    andTarget:self];
}

- (void)initSequence {
    AMSequencerSingleton *sequencerSingleton = [AMSequencerSingleton sharedSequencer];
    _mainSequencer = sequencerSingleton.sequencer;
    [_mainSequencer addSequencerDelegate:self];
    [self updateComponents];
}

- (void)initCellShiftProvider {
    _cellShiftProvider = [[AMCellShiftProvider alloc] initWith:_mainSequence
                                                    controller:self.tableView];
}

- (void)initBottomToolBar {
    [_bottomToolBar setBarTintColor:[AMAppearanceManager getGlobalColorTheme]];
    _toolbarItemsArray = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
    [_toolbarItemsArray addObject:flexibleItem];
    [self showLoopCountButtons];
    [self showEditButtons];
    
    NSString *editButtonImage = @"edit.png";
    if(_isEditEnabled) {
        editButtonImage = @"backRound.png";
    }
    
    _tempEditButton = [AMVisualUtils createBarButton:editButtonImage
                                              targer:self
                                            selector:@selector(onEditPressed:)
                                               color:[UIColor darkGrayColor]
                                                size:30];
    [_toolbarItemsArray addObject:_tempEditButton];
    [AMVisualUtils applyObjectsToToolBar:_bottomToolBar
                             fromAnArray:_toolbarItemsArray];
}

- (void)showLoopCountButtons {
    if(_isLoopCountEditEnabled && !_isEditEnabled) {
        _tempIncrementButton = [AMVisualUtils createBarButton:@"incloop.png"
                                                       targer:self
                                                     selector:@selector(onIncrementLoop:)
                                                         size:30];
        _tempDecrementButton = [AMVisualUtils createBarButton:@"decloop.png"
                                                       targer:self
                                                     selector:@selector(onDecrementLoop:)
                                                         size:30];
        AMSequenceStep *step = (AMSequenceStep *) _mainSequence.getActualObject;
        _tempLoopCountButton = [AMVisualUtils createBarButtonWithText:[NSString stringWithFormat:@"%ld", (long) step.getNumberOfLoops]
                                                               targer:nil
                                                             selector:nil];
        UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil
                                                                                   action:nil];
        [fixedItem setWidth:120.0f];
        [_toolbarItemsArray addObject:_tempDecrementButton];
        [_toolbarItemsArray addObject:_tempLoopCountButton];
        [_toolbarItemsArray addObject:_tempIncrementButton];
        [_toolbarItemsArray addObject:fixedItem];
    }
}

- (void)showEditButtons{
    if(_isEditEnabled) {
        _tempAddButton = [AMVisualUtils createBarButton:@"add.png"
                                                 targer:self
                                               selector:@selector(onAddStep:)
                                                  color:[UIColor darkGrayColor]
                                                   size:30];
        _tempDeleteButton = [AMVisualUtils createBarButton:@"delete.png"
                                                    targer:self
                                                  selector:@selector(onDeleteStep:)
                                                     color:[UIColor darkGrayColor]
                                                      size:30];
        _tempDuplicateButton = [AMVisualUtils createBarButton:@"copy.png"
                                                       targer:self
                                                     selector:@selector(onDuplicateStep:)
                                                        color:[UIColor darkGrayColor]
                                                         size:30];
        
        [_toolbarItemsArray addObject:_tempDeleteButton];
        [_toolbarItemsArray addObject:_tempAddButton];
        [_toolbarItemsArray addObject:_tempDuplicateButton];
    }
}

- (void)initTheme {
    [_bottomToolBar setBarTintColor:[AMAppearanceManager getGlobalColorTheme]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    _mainSequence = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [_mainSequence count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMSequenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier
                                                                    forIndexPath:indexPath];
    AMSequenceStep *stepAssigned = (AMSequenceStep *) [_mainSequence getObjectAtIndex:(NSUInteger) indexPath.row];
    [cell assignSequenceStep:stepAssigned];
    return cell;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_mainSequence setIndexAsActual:(NSUInteger) indexPath.row];
    [self updateComponents];
}

- (void)        tableView:(UITableView *)tableView
didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (IBAction)onAddStep:(id)sender {
    [_mainSequence addStep];
    AMSequenceStep *step = (AMSequenceStep *) _mainSequence.getActualObject;
    [step addStepDelegate:self];
}

- (IBAction)onDeleteStep:(id)sender {
    [_mainSequence removeActualObject];
}

- (IBAction)onDuplicateStep:(id)sender {
    [_mainSequence duplicateObject];
}

- (IBAction)onEditPressed:(id)sender {
    _isEditEnabled = !_isEditEnabled;
    [self initBottomToolBar];
}

- (IBAction)onIncrementLoop:(id)sender {
    AMSequenceStep *step = (AMSequenceStep *) _mainSequence.getActualObject;
    [step incrementLoop];
}

- (IBAction)onDecrementLoop:(id)sender {
    AMSequenceStep *step = (AMSequenceStep *) _mainSequence.getActualObject;
    [step decrementLoop];
}

- (IBAction)onLongPressed:(id)sender {
    [_cellShiftProvider performShifting:sender];
}

- (void)tempoHasBeenChanged {
    [self updateComponents];
}

- (void)tempoHasBeenTapped {
}

- (void)staveArrayHasBeenChanged {
    [self updateComponents];
}

- (void)staveSelectionHasBeenChanged {
    [self updateComponents];
}

- (void)staveMaxCountExceeded {
}

- (void)sequenceArrayHasBeenChanged {
    [self updateComponents];
}

- (void)sequenceSelectionHasBeenChanged {
    [self updateComponents];
}

- (void)sequenceMaxCountExceeded {
    if (_mainSequence.count >= [AMConfig maxStepCount]) {
        [self performSegueWithIdentifier:@"sw_step_popup" sender:self];
    }
}

- (void)sequenceStepPropertiesHasBeenChanged {
    [self updateComponents];
}

- (void)sequenceHasStarted {

}

- (void)sequenceHasStopped {

}

- (void)sequenceHasChanged {
    [self updateComponents];
}

- (void)updateComponents {
    _mainSequence = [_mainSequencer getSequence];
    [_mainSequence addArrayDelegate:_mainSequenceArrayResponder];
    AMSequenceStep *step = (AMSequenceStep *) _mainSequence.getActualObject;
    [step addStepDelegate:self];
    AMStave *stave = step.getStave;
    [stave addArrayDelegate:_mainStaveArrayResponder];
    [stave addStaveDelegate:self];
    [self stepLoopCounterUpdate];
    [self initBottomToolBar];
    [_tableView reloadData];
    [self updateIndexSelected];
}

- (void)updateIndexSelected {
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_mainSequence.getActualIndex
                                                            inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}

- (void)stepLoopCounterUpdate {
    AMSequenceStep *step = (AMSequenceStep *) _mainSequence.getActualObject;

    if (step.getStepType == REPEAT) {
        _isLoopCountEditEnabled = YES;
        return;
    }
    _isLoopCountEditEnabled = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"sw_step_popup"]) {
        AMPopupViewController *popupViewController = (AMPopupViewController *) segue.destinationViewController;
        [popupViewController setText:[AMConfig stepCountExceeded]];
    }
}

@end
