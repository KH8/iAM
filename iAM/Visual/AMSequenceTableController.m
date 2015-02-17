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

@end

@implementation AMSequenceTableController

static NSString * const reuseIdentifier = @"mySequenceStepCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initInitialSteps];
}

- (void)initInitialSteps{
    _sequenceSteps = [[NSMutableArray alloc] init];
    [_sequenceSteps addObject:@("STEP 1")];
    [_sequenceSteps addObject:@("STEP 2")];
    [_sequenceSteps addObject:@("STEP 3")];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    _sequenceSteps = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_sequenceSteps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMSequenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.stepTitle.text = _sequenceSteps[(NSUInteger) indexPath.row];
    cell.stepSubtitle.text  = @("4:4 x2 120BPM");
    return cell;
}

@end
