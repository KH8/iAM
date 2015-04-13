//
//  AMPropertiesTableViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 05.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "SWRevealViewController.h"
#import "AMPropertiesTableViewController.h"
#import "AMSoundsTableViewController.h"
#import "AMSequencerSingleton.h"

@interface AMPropertiesTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *track1SoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *track2SoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *track3SoundLabel;

@property NSArray *arrayOfPlayers;

@end

@implementation AMPropertiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSidebarMenu];
    [self loadIcons];
    [self loadMainObjects];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadLabels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    AMSequencer *sequencer = sequencerSingleton.sequencer;
    _arrayOfPlayers = sequencer.getArrayOfPlayers;
}

- (void)loadLabels{
    _track1SoundLabel.text = [(AMPlayer*)_arrayOfPlayers[0] getSoundKey];
    _track2SoundLabel.text = [(AMPlayer*)_arrayOfPlayers[1] getSoundKey];
    _track3SoundLabel.text = [(AMPlayer*)_arrayOfPlayers[2] getSoundKey];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *controller = [segue destinationViewController];
    AMSoundsTableViewController *rootController = controller.viewControllers.firstObject;
     
    if ([[segue identifier] isEqualToString:@"sw_track1"])
    {
        [rootController assignPlayer:_arrayOfPlayers[0]];
    }
    if ([[segue identifier] isEqualToString:@"sw_track2"])
    {
        [rootController assignPlayer:_arrayOfPlayers[1]];
    }
    if ([[segue identifier] isEqualToString:@"sw_track3"])
    {
        [rootController assignPlayer:_arrayOfPlayers[2]];
    }
}

@end
