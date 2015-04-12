//
//  AMSoundsTableViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 12.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSoundsTableViewController.h"

@interface AMSoundsTableViewController ()

@property NSMutableDictionary *dictionaryOfSounds;

@end

@implementation AMSoundsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDictionaryOfSounds];
}

- (void)initDictionaryOfSounds{
    _dictionaryOfSounds = [[NSMutableDictionary alloc] init];
    
    [_dictionaryOfSounds setObject:@"artificialHigh1" forKey:@"ARTIFICIAL HIGH 1"];
    [_dictionaryOfSounds setObject:@"artificialHigh2" forKey:@"ARTIFICIAL HIGH 2"];
    [_dictionaryOfSounds setObject:@"artificialLow1" forKey:@"ARTIFICIAL LOW 1"];
    [_dictionaryOfSounds setObject:@"artificialLow2" forKey:@"ARTIFICIAL LOW 2"];
    [_dictionaryOfSounds setObject:@"click1" forKey:@"CLICK 1"];
    [_dictionaryOfSounds setObject:@"click2" forKey:@"CLICK 2"];
    [_dictionaryOfSounds setObject:@"clockTick1" forKey:@"CLOCK TICK 1"];
    [_dictionaryOfSounds setObject:@"clockTick2" forKey:@"CLOCK TICK 2"];
    [_dictionaryOfSounds setObject:@"natural1" forKey:@"NATURAL 1"];
    [_dictionaryOfSounds setObject:@"natural2" forKey:@"NATURAL 2"];
    [_dictionaryOfSounds setObject:@"natural3" forKey:@"NATURAL 3"];
    [_dictionaryOfSounds setObject:@"stickHigh" forKey:@"STICK HIGH"];
    [_dictionaryOfSounds setObject:@"stickLow" forKey:@"STICK LOW"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dictionaryOfSounds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"soundCell" forIndexPath:indexPath];
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"SOUNDS";
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"Select one sound to be applied to the track.";
}

@end
