//
//  AMSequenceTableController.m
//  iAM
//
//  Created by Krzysztof Reczek on 16.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequenceTableController.h"
#import "AMSequenceTableViewCell.h"
#import "AMSequence.h"

@interface AMSequenceTableController ()

@property AMSequence *mainSequence;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AMSequenceTableController

static NSString * const reuseIdentifier = @"mySequenceStepCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSequence];
    [self changeIndexSelected:0];
}

- (void)initSequence{
    _mainSequence = [[AMSequence alloc] init];
    _mainSequence.visualDelegate = self;
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
    AMSequenceStep *stepAssigned = [_mainSequence getStepAtIndex:indexPath.row];
    [cell assignSequenceStep:stepAssigned];
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainSequence setIndexAsActual:indexPath.row];
    [_mainSequence getStepAtIndex:indexPath.row];
}

- (IBAction)onAddStep:(id)sender {
    [_mainSequence addNewStep];
}

- (IBAction)onDeleteStep:(id)sender {
    [_mainSequence removeStep];
}

- (void)reloadView {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *ipath = [self.tableView indexPathForSelectedRow];
        [_tableView reloadData];
        [self.tableView selectRowAtIndexPath:ipath
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

- (void)selectionHasBeenChanged{
    [self changeIndexSelected:_mainSequence.getActualIndex];
}

@end
