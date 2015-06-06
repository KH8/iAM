//
//  AMSoundsTableViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 12.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSoundsTableViewController.h"
#import "AMSoundTableViewCell.h"
#import "SWRevealViewController.h"

@interface AMSoundsTableViewController ()

@property AMMutableArray *arrayOfSounds;
@property AMPlayer *amPlayer;
@property NSIndexPath *indexSelected;

@end

@implementation AMSoundsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDictionaryOfSounds];
    [self initIndexSelection];
    [self initSizes];
    [self initColors];
}

- (void)initSizes {
    SWRevealViewController *revealController = [self revealViewController];
    [revealController setRearViewRevealWidth:0];
    [revealController setRearViewRevealOverdraw:0];
    [revealController setRightViewRevealWidth:0];
    [revealController setRightViewRevealOverdraw:0];
}

- (void)initColors {
    UIColor *backgrounColor = [UINavigationBar appearance].barTintColor;
    [self.view setBackgroundColor:backgrounColor];
}

- (void)initDictionaryOfSounds {
    _arrayOfSounds = [[AMMutableArray alloc] initWithMaxCount:26];

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

- (void)initIndexSelection {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView selectRowAtIndexPath:_indexSelected
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionNone];
    });
}

- (void)assignPlayer:(AMPlayer *)player {
    _amPlayer = player;
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

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMSoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"soundCell"
                                                                 forIndexPath:indexPath];
    NSString *key = _arrayOfSounds[2 * indexPath.row + 1];
    NSString *value = _arrayOfSounds[2 * indexPath.row];

    [cell assignSoundKey:key];
    [cell assignSoundValue:value];
    [cell assignPlayer:_amPlayer];

    if ([[_amPlayer getSoundKey] isEqualToString:key]) {
        _indexSelected = indexPath;
    }

    return cell;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_arrayOfSounds setIndexAsActual:indexPath.row];
}

- (void)        tableView:(UITableView *)tableView
didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return @"SOUNDS";
}

- (NSString *)tableView:(UITableView *)tableView
titleForFooterInSection:(NSInteger)section {
    return @"Select one sound that will be applied to the track.";
}


@end
