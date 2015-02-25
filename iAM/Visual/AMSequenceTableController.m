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

@property UIBarButtonItem *tempAddButton;
@property UIBarButtonItem *tempDeleteButton;

@end

@implementation AMSequenceTableController

static NSString * const reuseIdentifier = @"mySequenceStepCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSequence];
    [self initBottomToolBar];
    [self changeIndexSelected:0];
}

- (void)initSequence{
    AMSequencerSingleton *sequencerSingleton = [AMSequencerSingleton sharedSequencer];
    _mainSequencer = sequencerSingleton.sequencer;
    _mainSequencer.sequencerSyncDelegate = self;
    _mainSequence = [_mainSequencer getSequence];
    _mainSequence.visualDelegate = self;
}

- (void)initBottomToolBar{
    UIImage *addImage = [[UIImage imageNamed:@"add.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _tempAddButton = [[UIBarButtonItem alloc] initWithImage:addImage style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(onAddStep:)];
    _tempAddButton.tintColor = [UIColor orangeColor];
    [self replaceObjectInToolBarAtIndex:3 withObject:_tempAddButton];
    UIView *addButtonView= (UIView *)[_bottomToolBar.subviews objectAtIndex:3];
    addButtonView.frame = CGRectMake(30, 30, 30, 30);
    
    UIImage *deleteImage = [[UIImage imageNamed:@"delete.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _tempDeleteButton = [[UIBarButtonItem alloc] initWithImage:deleteImage style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(onDeleteStep:)];
    _tempDeleteButton.tintColor = [UIColor orangeColor];
    [self replaceObjectInToolBarAtIndex:2 withObject:_tempDeleteButton];
    UIView *deleteButtonView= (UIView *)[_bottomToolBar.subviews objectAtIndex:2];
    deleteButtonView.frame = CGRectMake(30, 30, 30, 30);
}

- (void)replaceObjectInToolBarAtIndex: (NSInteger)anIndex withObject: (NSObject*)anObject{
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

- (UITableViewCell*)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (IBAction)onAddStep:(id)sender {
    [_mainSequence addNewStep];
}

- (IBAction)onDeleteStep:(id)sender {
    [_mainSequence removeStep];
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
}

- (void)stepParametersHaveBeenChanged{
    [_tableView reloadData];
}

@end
