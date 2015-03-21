//
//  AMMenuTableViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 16.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "SWRevealViewController.h"
#import "AMMenuTableViewController.h"
#import "AMSequencerSingleton.h"
#import "AMSequence.h"
#import "AMMutableArray.h"

@interface AMMenuTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property AMMutableArray *arrayOfSequences;

@end

@implementation AMMenuTableViewController

static NSString * const reuseIdentifier = @"myMenuStepCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSidebarMenu];
    [self loadIcons];
    [self loadMainObjects];
}

- (void)loadSidebarMenu{
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    [_sideMenuButton setTarget: self.revealViewController];
    [_sideMenuButton setAction: @selector( revealToggle: )];
}

- (void)loadIcons{
    UIBarButtonItem *originalLeftButton = _navigationBarItem.leftBarButtonItem;
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.tintColor = [UIColor orangeColor];
    face.bounds = CGRectMake( 26, 26, 26, 26 );
    [face setImage:[[UIImage imageNamed:@"menu.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
          forState:UIControlStateNormal];
    [face addTarget:originalLeftButton.target
             action:originalLeftButton.action
   forControlEvents:UIControlEventTouchDown];
    _navigationBarItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:face];
}

- (void)loadMainObjects{
    AMSequencerSingleton *sequencerSingleton = [AMSequencerSingleton sharedSequencer];
    _arrayOfSequences = sequencerSingleton.arrayOfSequences;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrayOfSequences count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [_arrayOfSequences[(NSUInteger) indexPath.row] getName];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"CREATED: %@", dateString];
    
    if(indexPath.row == 0){
        cell.textLabel.textColor = [UIColor orangeColor];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (IBAction)onAddAction:(id)sender {
    AMSequence *newSequence = [[AMSequence alloc] init];
    [_arrayOfSequences addObject:newSequence];
    [_tableView reloadData];
}

- (IBAction)onDeleteAction:(id)sender {
    [_arrayOfSequences removeActualObject];
    [_tableView reloadData];
}

@end
