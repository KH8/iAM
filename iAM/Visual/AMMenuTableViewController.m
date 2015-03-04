//
//  AMMenuTableViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 16.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMMenuTableViewController.h"

@interface AMMenuTableViewController ()

@property NSMutableArray *menuItems;

@end

@implementation AMMenuTableViewController

static NSString * const reuseIdentifier = @"myMenuStepCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMenuItems];
}

- (void)initMenuItems{
    _menuItems = [[NSMutableArray alloc] init];
    [_menuItems addObject:@("New Sequence")];
    [_menuItems addObject:@("Save Sequence")];
    [_menuItems addObject:@("Properties")];
    [_menuItems addObject:@("About")];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    _menuItems = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = _menuItems[(NSUInteger) indexPath.row];
    
    if(indexPath.row == 0){
        cell.textLabel.textColor = [UIColor orangeColor];
    }
    
    return cell;
}

@end
