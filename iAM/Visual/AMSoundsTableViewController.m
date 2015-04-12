//
//  AMSoundsTableViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 12.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSoundsTableViewController.h"
#import "AMSoundTableViewCell.h"

@interface AMSoundsTableViewController ()

@property AMMutableArray *arrayOfSounds;

@end

@implementation AMSoundsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDictionaryOfSounds];
    [self updateIndexSelected];
}

- (void)initDictionaryOfSounds{
    _arrayOfSounds = [[AMMutableArray alloc] init];
    
    [_arrayOfSounds addObjectAtTheEnd:@"artificialHigh1"];
    [_arrayOfSounds addObjectAtTheEnd:@"ARTIFICIAL HIGH 1"];
    [_arrayOfSounds addObjectAtTheEnd:@"artificialHigh2"];
    [_arrayOfSounds addObjectAtTheEnd:@"ARTIFICIAL HIGH 2"];
    [_arrayOfSounds addObjectAtTheEnd:@"artificialLow1"];
    [_arrayOfSounds addObjectAtTheEnd:@"ARTIFICIAL LOW 1"];
    [_arrayOfSounds addObjectAtTheEnd:@"artificialLow2"];
    [_arrayOfSounds addObjectAtTheEnd:@"ARTIFICIAL LOW 2"];
    [_arrayOfSounds addObjectAtTheEnd:@"click1"];
    [_arrayOfSounds addObjectAtTheEnd:@"CLICK 1"];
    [_arrayOfSounds addObjectAtTheEnd:@"click2"];
    [_arrayOfSounds addObjectAtTheEnd:@"CLICK 2"];
    [_arrayOfSounds addObjectAtTheEnd:@"clockTick1"];
    [_arrayOfSounds addObjectAtTheEnd:@"CLOCK TICK 1"];
    [_arrayOfSounds addObjectAtTheEnd:@"clockTick2"];
    [_arrayOfSounds addObjectAtTheEnd:@"CLOCK TICK 2"];
    [_arrayOfSounds addObjectAtTheEnd:@"natural1"];
    [_arrayOfSounds addObjectAtTheEnd:@"NATURAL 1"];
    [_arrayOfSounds addObjectAtTheEnd:@"natural2"];
    [_arrayOfSounds addObjectAtTheEnd:@"NATURAL 2"];
    [_arrayOfSounds addObjectAtTheEnd:@"natural3"];
    [_arrayOfSounds addObjectAtTheEnd:@"NATURAL 3"];
    [_arrayOfSounds addObjectAtTheEnd:@"stickHigh"];
    [_arrayOfSounds addObjectAtTheEnd:@"STICK HIGH"];
    [_arrayOfSounds addObjectAtTheEnd:@"stickLow"];
    [_arrayOfSounds addObjectAtTheEnd:@"STICK LOW"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 13;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_arrayOfSounds setIndexAsActual:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMSoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"soundCell"
                                                            forIndexPath:indexPath];
    [cell assignSoundKey:_arrayOfSounds[2*indexPath.row+1]];
    [cell assignSoundValue:_arrayOfSounds[2*indexPath.row]];
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
    return @"SOUNDS";
}

- (NSString*)tableView:(UITableView *)tableView
titleForFooterInSection:(NSInteger)section{
    return @"Select one sound to be applied to the track.";
}

- (void)updateIndexSelected {
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_arrayOfSounds.getActualIndex
                                                            inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}

@end
