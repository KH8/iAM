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

@interface AMSequenceTableController ()

@property AMSequencer *mainSequencer;
@property AMSequence *mainSequence;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property UIBarButtonItem *tempDeleteButton;
@property UIBarButtonItem *tempAddButton;

@property UIBarButtonItem *tempLoopCountButton;
@property UIBarButtonItem *tempIncrementButton;
@property UIBarButtonItem *tempDecrementButton;

@end

@implementation AMSequenceTableController

static NSString * const reuseIdentifier = @"mySequenceStepCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSequence];
    [self initBottomToolBar];
    [self changeIndexSelected:0];
    [self stepLoopCounterUpdate];
}

- (void)initSequence{
    AMSequencerSingleton *sequencerSingleton = [AMSequencerSingleton sharedSequencer];
    _mainSequencer = sequencerSingleton.sequencer;
    _mainSequencer.sequencerSyncDelegate = self;
    _mainSequence = [_mainSequencer getSequence];
    _mainSequence.visualDelegate = self;
}

- (void)initBottomToolBar{
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

- (void)setBottomBarButton: (UIBarButtonItem *)button
           withPictureName: (NSString *)pictureName
                  selector: (SEL)selector
            buttonPosition: (NSUInteger)position
                      size: (NSInteger)size
                     color: (UIColor*)color{
    UIImage *faceImage = [[UIImage imageNamed:pictureName]
                          imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.tintColor = color;
    face.bounds = CGRectMake( size, size, size, size );
    [face setImage:faceImage
          forState:UIControlStateNormal];
    [face addTarget:self
             action:selector
   forControlEvents:UIControlEventTouchDown];
    
    button = [[UIBarButtonItem alloc] initWithCustomView:face];
    [self replaceObjectInToolBarAtIndex:position withObject:button];
}

- (void)replaceObjectInToolBarAtIndex: (NSInteger)anIndex withObject: (NSObject*)anObject{
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    for (NSObject *item in _bottomToolBar.items){
        [toolbarItems addObject:item];
    }
    toolbarItems[(NSUInteger) anIndex] = anObject;
    _bottomToolBar.items = toolbarItems;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    _mainSequence = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return [_mainSequence count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AMSequenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier
                                                                    forIndexPath:indexPath];
    AMSequenceStep *stepAssigned = [_mainSequence getStepAtIndex:(NSUInteger) indexPath.row];
    [cell assignSequenceStep:stepAssigned];
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainSequence setIndexAsActual:(NSUInteger) indexPath.row];
    [_mainSequence getStepAtIndex:(NSUInteger) indexPath.row];
}

- (void)tableView:(UITableView *)tableView
didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (IBAction)onAddStep:(id)sender{
    [_mainSequence addNewStep];
}

- (IBAction)onDeleteStep:(id)sender{
    [_mainSequence removeStep];
}

- (IBAction)onIncrementLoop:(id)sender{
    AMSequenceStep *step = _mainSequence.getActualStep;
    step.visualDelegate = self;
    [step incrementLoop];
}

- (IBAction)onDecrementLoop:(id)sender{
    AMSequenceStep *step = _mainSequence.getActualStep;
    step.visualDelegate = self;
    [step decrementLoop];
}

- (void)reloadView{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [_tableView reloadData];
        [self.tableView selectRowAtIndexPath:indexPath
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionNone];
    });
}

- (void)changeIndexSelected: (NSUInteger)newIndex {
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:newIndex
                                                            inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}

- (void)sequenceHasBeenChanged{
    [self reloadView];
}

- (void)stepHasBeenChanged{
    [self changeIndexSelected:(NSUInteger) _mainSequence.getActualIndex];
    [self stepLoopCounterUpdate];
}

- (void)stepParametersHaveBeenChanged{
    [_tableView reloadData];
    [self changeIndexSelected:(NSUInteger) _mainSequence.getActualIndex];
}

- (void)sequenceStepPropertiesHasBeenChanged{
    [self stepLoopCounterUpdate];
}

- (void)stepLoopCounterUpdate{
    AMSequenceStep *step = _mainSequence.getActualStep;
    step.visualDelegate = self;
    
    if(step.getStepType != REPEAT){
        [self hideAllLoopCountButtons];
        return;
    }
    [self showAllLoopCountButtons];
}

- (void)hideAllLoopCountButtons{
    [self hideButton:_tempIncrementButton
          atPosition:3];
    [self hideButton:_tempDecrementButton
          atPosition:1];
    [self hideButton:_tempLoopCountButton
          atPosition:2];
}

- (void)showAllLoopCountButtons{
    [self setBottomBarButton:_tempIncrementButton
             withPictureName:@"incloop.png"
                    selector:@selector(onIncrementLoop:)
              buttonPosition:3
                        size:22
                       color:[UIColor orangeColor]];
    [self setBottomBarButton:_tempDecrementButton
             withPictureName:@"decloop.png"
                    selector:@selector(onDecrementLoop:)
              buttonPosition:1
                        size:22
                       color:[UIColor orangeColor]];
    
    AMSequenceStep *step = _mainSequence.getActualStep;
    _tempLoopCountButton = [[UIBarButtonItem alloc] init];
    _tempLoopCountButton.title = [NSString stringWithFormat:@"%ld", (long)step.getNumberOfLoops];
    _tempLoopCountButton.tintColor = [UIColor orangeColor];
    [self replaceObjectInToolBarAtIndex:2
                             withObject:_tempLoopCountButton];
}

- (void)hideButton: (UIBarButtonItem*)button
        atPosition: (NSUInteger)position{
    button = [[UIBarButtonItem alloc] init];
    button.style = UIBarButtonItemStylePlain;
    button.enabled = false;
    button.title = nil;
    [self replaceObjectInToolBarAtIndex:position
                             withObject:button];
}

@end
