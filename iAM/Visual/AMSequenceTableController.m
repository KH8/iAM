//
//  AMSequenceTableController.m
//  iAM
//
//  Created by Krzysztof Reczek on 16.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequenceTableController.h"
#import "AMSequenceTableViewCell.h"
#import "AMSequencerSingleton.h"

@interface AMSequenceTableController ()

@property AMSequencer *mainSequencer;
@property AMSequence *mainSequence;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property UIBarButtonItem *tempAddButton;
@property UIBarButtonItem *tempDeleteButton;

@end

@implementation AMSequenceTableController

static NSString * const reuseIdentifier = @"mySequenceStepCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSequence];
    [self initBottomToolBar];
    [self changeIndexSelected:0];
}

- (void)initSequence{
    AMSequencerSingleton *sequencerSingleton = [AMSequencerSingleton sharedSequencer];
    _mainSequencer = sequencerSingleton.sequencer;
    _mainSequencer.sequencerSyncDelegate = self;
    _mainSequence = [_mainSequencer getSequence];
    _mainSequence.visualDelegate = self;
}

- (void)initBottomToolBar{
    [self setBottomBarButton:_tempAddButton
             withPictureName:@"addloop.png"
                    selector:@selector(onAddStep:)
              buttonPosition:3];
    [self setBottomBarButton:_tempDeleteButton
             withPictureName:@"subloop.png"
                    selector:@selector(onDeleteStep:)
              buttonPosition:1];
    [self setBottomBarButton:_tempAddButton
             withPictureName:@"add.png"
                    selector:@selector(onAddStep:)
              buttonPosition:6];
    [self setBottomBarButton:_tempDeleteButton
             withPictureName:@"delete.png"
                    selector:@selector(onDeleteStep:)
              buttonPosition:5];
}

- (void)setBottomBarButton: (UIBarButtonItem *)button
           withPictureName: (NSString *)pictureName
                  selector: (SEL)selector
            buttonPosition: (NSUInteger)position{
    UIImage *faceImage = [[UIImage imageNamed:pictureName]
                          imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.bounds = CGRectMake( 30, 30, 30, 30 );
    [face setImage:faceImage
          forState:UIControlStateNormal];
    [face addTarget:self
             action:selector
   forControlEvents:UIControlEventTouchDown];
    
    button = [[UIBarButtonItem alloc] initWithCustomView:face];
    [self replaceObjectInToolBarAtIndex:position withObject:button];
}

- (void)replaceObjectInToolBarAtIndex: (NSInteger)anIndex withObject: (NSObject*)anObject{
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    for (NSObject *item in _bottomToolBar.items) {
        [toolbarItems addObject:item];
    }
    toolbarItems[(NSUInteger) anIndex] = anObject;
    _bottomToolBar.items = toolbarItems;
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
    AMSequenceStep *stepAssigned = [_mainSequence getStepAtIndex:(NSUInteger) indexPath.row];
    [cell assignSequenceStep:stepAssigned];
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainSequence setIndexAsActual:(NSUInteger) indexPath.row];
    [_mainSequence getStepAtIndex:(NSUInteger) indexPath.row];
}

- (IBAction)onAddStep:(id)sender {
    [_mainSequence addNewStep];
}

- (IBAction)onDeleteStep:(id)sender {
    [_mainSequence removeStep];
}

- (void)reloadView {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [_tableView reloadData];
        [self.tableView selectRowAtIndexPath:indexPath
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

- (void)stepHasBeenChanged{
    [self changeIndexSelected:(NSUInteger) _mainSequence.getActualIndex];
}

- (void)stepParametersHaveBeenChanged{
    [_tableView reloadData];
    [self changeIndexSelected:(NSUInteger) _mainSequence.getActualIndex];
}

@end
