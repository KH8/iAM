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
#import "AMConfig.h"

@interface AMSequenceTableController ()

@property AMSequencer *mainSequencer;
@property AMSequence *mainSequence;

@property AMMutableArrayResponder *mainSequenceArrayResponder;
@property AMMutableArrayResponder *mainStaveArrayResponder;

@property(weak, nonatomic) IBOutlet UITableView *tableView;

@property UIBarButtonItem *tempDeleteButton;
@property UIBarButtonItem *tempAddButton;

@property UIBarButtonItem *tempLoopCountButton;
@property UIBarButtonItem *tempIncrementButton;
@property UIBarButtonItem *tempDecrementButton;

@end

@implementation AMSequenceTableController

static NSString *const reuseIdentifier = @"mySequenceStepCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initResponders];
    [self initSequence];
    [self initBottomToolBar];
    [self updateIndexSelected];
    [self stepLoopCounterUpdate];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateComponents];

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

- (void)initBottomToolBar {
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
    [AMVisualUtils replaceObjectInToolBar:_bottomToolBar
                                  atIndex:6
                               withObject:_tempAddButton];
    [AMVisualUtils replaceObjectInToolBar:_bottomToolBar
                                  atIndex:5
                               withObject:_tempDeleteButton];
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

- (IBAction)onIncrementLoop:(id)sender {
    AMSequenceStep *step = (AMSequenceStep *) _mainSequence.getActualObject;
    [step incrementLoop];
}

- (IBAction)onDecrementLoop:(id)sender {
    AMSequenceStep *step = (AMSequenceStep *) _mainSequence.getActualObject;
    [step decrementLoop];
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
    [self reloadView];
    [self updateIndexSelected];
    [self stepLoopCounterUpdate];
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
        [self showAllLoopCountButtons];
        return;
    }
    [self hideAllLoopCountButtons];
}

- (void)hideAllLoopCountButtons {
    [self hideButton:_tempIncrementButton
          atPosition:3];
    [self hideButton:_tempDecrementButton
          atPosition:1];
    [self hideButton:_tempLoopCountButton
          atPosition:2];
}

- (void)showAllLoopCountButtons {
    _tempIncrementButton = [AMVisualUtils createBarButton:@"incloop.png"
                                             targer:self
                                           selector:@selector(onIncrementLoop:)
                                               size:22];
    _tempDecrementButton = [AMVisualUtils createBarButton:@"decloop.png"
                                             targer:self
                                           selector:@selector(onDecrementLoop:)
                                               size:22];
    AMSequenceStep *step = (AMSequenceStep *) _mainSequence.getActualObject;
    _tempLoopCountButton = [AMVisualUtils createBarButtonWithText:[NSString stringWithFormat:@"%ld", (long) step.getNumberOfLoops]
                                                           targer:nil
                                                         selector:nil];
    [AMVisualUtils replaceObjectInToolBar:_bottomToolBar
                                  atIndex:3
                               withObject:_tempIncrementButton];
    [AMVisualUtils replaceObjectInToolBar:_bottomToolBar
                                  atIndex:1
                               withObject:_tempDecrementButton];
    [AMVisualUtils replaceObjectInToolBar:_bottomToolBar
                                  atIndex:2
                               withObject:_tempLoopCountButton];
}

- (void)hideButton:(UIBarButtonItem *)button
        atPosition:(NSUInteger)position {
    button = [[UIBarButtonItem alloc] init];
    button.style = UIBarButtonItemStylePlain;
    button.enabled = false;
    button.title = nil;
    [AMVisualUtils replaceObjectInToolBar:_bottomToolBar
                                  atIndex:position
                               withObject:button];
}

- (void)reloadView {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [_tableView reloadData];
        [self.tableView selectRowAtIndexPath:indexPath
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionNone];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"sw_step_popup"]) {
        AMPopupViewController *popupViewController = (AMPopupViewController *) segue.destinationViewController;
        [popupViewController setText:[AMConfig stepCountExceeded]];
    }
}

@end
