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

@interface AMSequenceMenuTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property AMMutableArray *arrayOfSequences;
@property AMSequencer *sequencer;

@end

@implementation AMSequenceMenuTableViewController

static NSString * const reuseIdentifier = @"myMenuStepCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainObjects];
    [self updateIndexSelected];
}

- (void)loadMainObjects{
    AMSequencerSingleton *sequencerSingleton = [AMSequencerSingleton sharedSequencer];
    _arrayOfSequences = sequencerSingleton.arrayOfSequences;
    _sequencer = sequencerSingleton.sequencer;
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
    AMSequence *sequenceAssigned = _arrayOfSequences[(NSUInteger) indexPath.row];
    AMSequenceMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier
                                                                        forIndexPath:indexPath];
    cell.textLabel.text = sequenceAssigned.getName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"CREATED: %@", sequenceAssigned.getCreationDateString];
    
    if(indexPath.row == 0){
        cell.textLabel.textColor = [UIColor orangeColor];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
    return @"";
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMSequence *sequenceSelected = _arrayOfSequences[indexPath.row];
    [_sequencer setSequence:sequenceSelected];
}

- (IBAction)onAddAction:(id)sender {
    AMSequence *newSequence = [[AMSequence alloc] initWithSubComponents];
    [_arrayOfSequences addObject:newSequence];
    [_tableView reloadData];
    [self updateIndexSelected];
}

- (IBAction)onDeleteAction:(id)sender {
    [_arrayOfSequences removeActualObject];
    [_tableView reloadData];
    [self updateIndexSelected];
}

- (void)updateIndexSelected {
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_arrayOfSequences.getActualIndex
                                                            inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}

@end
