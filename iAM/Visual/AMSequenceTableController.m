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
    [_sequenceSteps addObject:[[AMSequenceStep alloc] initWithIndex:1]];
    [_sequenceSteps addObject:[[AMSequenceStep alloc] initWithIndex:2]];
    [_sequenceSteps addObject:[[AMSequenceStep alloc] initWithIndex:3]];
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
    [cell assignSequenceStep:_sequenceSteps[indexPath.row]];
    return cell;
}

@end
