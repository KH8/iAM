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
    [self setBottomBarButton:_tempAddButton
             withPictureName:@"add.png"
                    selector:@selector(onAddStep:)
              buttonPosition:6
                        size:30
                       color:[UIColor darkGrayColor]];
    [self setBottomBarButton:_tempDeleteButton
             withPictureName:@"delete.png"
                    selector:@selector(onDeleteStep:)
              buttonPosition:5
                        size:30
                       color:[UIColor darkGrayColor]];
}

- (void)setBottomBarButton:(UIBarButtonItem *)button
           withPictureName:(NSString *)pictureName
                  selector:(SEL)selector
            buttonPosition:(NSUInteger)position
                      size:(NSInteger)size
                     color:(UIColor *)color {
    UIImage *faceImage = [[UIImage imageNamed:pictureName]
            imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.tintColor = color;
    face.bounds = CGRectMake(size, size, size, size);
    [face setImage:faceImage
          forState:UIControlStateNormal];
    [face addTarget:self
             action:selector
   forControlEvents:UIControlEventTouchDown];

    button = [[UIBarButtonItem alloc] initWithCustomView:face];
    [self replaceObjectInToolBarAtIndex:position withObject:button];
}

- (void)replaceObjectInToolBarAtIndex:(NSInteger)anIndex withObject:(NSObject *)anObject {
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    for (NSObject *item in _bottomToolBar.items) {
        [toolbarItems addObject:item];
    }
    toolbarItems[(NSUInteger) anIndex] = anObject;
    _bottomToolBar.items = toolbarItems;
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
    [self setBottomBarButton:_tempIncrementButton
             withPictureName:@"incloop.png"
                    selector:@selector(onIncrementLoop:)
              buttonPosition:3
                        size:22
                       color:[[UIView appearance] tintColor]];
    [self setBottomBarButton:_tempDecrementButton
             withPictureName:@"decloop.png"
                    selector:@selector(onDecrementLoop:)
              buttonPosition:1
                        size:22
                       color:[[UIView appearance] tintColor]];

    AMSequenceStep *step = (AMSequenceStep *) _mainSequence.getActualObject;
    _tempLoopCountButton = [[UIBarButtonItem alloc] init];
    _tempLoopCountButton.title = [NSString stringWithFormat:@"%ld", (long) step.getNumberOfLoops];
    _tempLoopCountButton.tintColor = [[UIView appearance] tintColor];
    [self replaceObjectInToolBarAtIndex:2
                             withObject:_tempLoopCountButton];
}

- (void)hideButton:(UIBarButtonItem *)button
        atPosition:(NSUInteger)position {
    button = [[UIBarButtonItem alloc] init];
    button.style = UIBarButtonItemStylePlain;
    button.enabled = false;
    button.title = nil;
    [self replaceObjectInToolBarAtIndex:position
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
