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
#import "AMVolumeSlider.h"

@interface AMPropertiesTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *track1SoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *track2SoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *track3SoundLabel;
@property (weak, nonatomic) IBOutlet AMVolumeSlider *generalSlider;
@property (weak, nonatomic) IBOutlet AMVolumeSlider *track1Slider;
@property (weak, nonatomic) IBOutlet AMVolumeSlider *track2Slider;
@property (weak, nonatomic) IBOutlet AMVolumeSlider *track3Slider;

@property NSTimer *mainTimer;
@property NSRunLoop *runner;
@property BOOL playSound;
@property AMPlayer *player;

@property NSArray *arrayOfPlayers;

@end

@implementation AMPropertiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSidebarMenu];
    [self loadIcons];
    [self loadMainObjects];
    [self loadPlayBack];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadLabels];
    [self loadSliders];
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
    face.tintColor = [[UIView appearance] tintColor];
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

- (void)loadPlayBack{
    _playSound = NO;
    _mainTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                  target:self
                                                selector:@selector(onTick)
                                                userInfo:nil
                                                 repeats:YES];
    _runner = [NSRunLoop currentRunLoop];
    [_runner addTimer:_mainTimer forMode: NSRunLoopCommonModes];
}

- (void)loadLabels{
    _track1SoundLabel.text = [(AMPlayer*)_arrayOfPlayers[0] getSoundKey];
    _track2SoundLabel.text = [(AMPlayer*)_arrayOfPlayers[1] getSoundKey];
    _track3SoundLabel.text = [(AMPlayer*)_arrayOfPlayers[2] getSoundKey];
}

- (void)loadSliders{
    _generalSlider.value = [[(AMPlayer*)_arrayOfPlayers[0] getGeneralVolumeFactor] floatValue];
    _track1Slider.value = [[(AMPlayer*)_arrayOfPlayers[0] getVolumeFactor] floatValue];
    _track2Slider.value = [[(AMPlayer*)_arrayOfPlayers[1] getVolumeFactor] floatValue];
    _track3Slider.value = [[(AMPlayer*)_arrayOfPlayers[2] getVolumeFactor] floatValue];
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

- (IBAction)generalTrackVolumeChanged:(id)sender {
    [(AMPlayer*)_arrayOfPlayers[0] setGeneralVolumeFactor:[[NSNumber alloc] initWithFloat:_generalSlider.value]];
    [(AMPlayer*)_arrayOfPlayers[1] setGeneralVolumeFactor:[[NSNumber alloc] initWithFloat:_generalSlider.value]];
    [(AMPlayer*)_arrayOfPlayers[2] setGeneralVolumeFactor:[[NSNumber alloc] initWithFloat:_generalSlider.value]];
    _player = (AMPlayer*)_arrayOfPlayers[0];
    _playSound = YES;
}

- (IBAction)track1VolumeChanged:(id)sender {
    [self trackVolumeChanged:(AMPlayer*)_arrayOfPlayers[0]
                   withValue:_track1Slider.value];
}

- (IBAction)track2VolumeChanged:(id)sender {
    [self trackVolumeChanged:(AMPlayer*)_arrayOfPlayers[1]
                   withValue:_track2Slider.value];
}

- (IBAction)track3VolumeChanged:(id)sender {
    [self trackVolumeChanged:(AMPlayer*)_arrayOfPlayers[2]
                   withValue:_track3Slider.value];
}

- (void)trackVolumeChanged:(AMPlayer*)player withValue:(float)volume{
    [player setVolumeFactor:[[NSNumber alloc] initWithFloat:volume]];
    _player = player;
    _playSound = YES;
}

- (void)onTick {
    if(_playSound){
        _playSound = NO;
        [_player playSound];
    }
}

@end
