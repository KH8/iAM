//
//  AMSequenceTableController.m
//  iAM
//
//  Created by Krzysztof Reczek on 16.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequenceTableController.h"
#import "AMSequenceTableViewCell.h"

@interface AMSequenceTableController ()

@property NSMutableArray *sequenceSteps;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSUInteger indexSelected;

@end

@implementation AMSequenceTableController

static NSString * const reuseIdentifier = @"mySequenceStepCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initInitialSteps];
}

- (void)initInitialSteps{
    _sequenceSteps = [[NSMutableArray alloc] init];
    [_sequenceSteps addObject:[[AMSequenceStep alloc] initWithIndex:1]];
    [_sequenceSteps addObject:[[AMSequenceStep alloc] initWithIndex:2]];
    [_sequenceSteps addObject:[[AMSequenceStep alloc] initWithIndex:3]];
    [self changeIndexSelected:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    _sequenceSteps = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [_sequenceSteps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMSequenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell assignSequenceStep:_sequenceSteps[indexPath.row]];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexSelected = (NSUInteger)indexPath.row;
}

- (void)tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath{
    [_sequenceSteps[indexPath.row] setNextStepType];
}

- (IBAction)onAddStep:(id)sender {
    NSInteger newIndex = _sequenceSteps.count + 1;
    [_sequenceSteps insertObject:[[AMSequenceStep alloc] initWithIndex:newIndex]
                         atIndex:_indexSelected + 1];
    [self reloadView];
}

- (IBAction)onDeleteStep:(id)sender {
    if(_sequenceSteps.count == 1) return;
    AMSequenceStep *objectToBeRemoved = _sequenceSteps[_indexSelected];
    [_sequenceSteps removeObject:objectToBeRemoved];
    [self changeIndexSelected:0];
    [self reloadView];
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
    _indexSelected = newIndex;
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:newIndex
                                                            inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}

@end
