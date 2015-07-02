//
//  AMPropertiesTableViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 05.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "Utils/AMRevealViewUtils.h"
#import "AMAppearanceManager.h"
#import "AMTrackConfiguration.h"
#import "AppDelegate.h"
#import "AMPropertiesTableViewController.h"
#import "AMSoundsTableViewController.h"
#import "AMPopupViewController.h"
#import "AMSequencerSingleton.h"
#import "AMVisualUtils.h"
#import "AMConfig.h"

@interface AMPropertiesTableViewController ()

@property AppDelegate *appDelegate;

@property(weak, nonatomic) IBOutlet AMVolumeSlider *generalSlider;
@property(weak, nonatomic) IBOutlet AMVolumeSlider *track1Slider;
@property(weak, nonatomic) IBOutlet AMVolumeSlider *track2Slider;
@property(weak, nonatomic) IBOutlet AMVolumeSlider *track3Slider;
@property(weak, nonatomic) IBOutlet UIButton *tintColorButton;
@property(weak, nonatomic) IBOutlet UIButton *colorThemeButton;
@property(weak, nonatomic) IBOutlet UIButton *resetButton;
@property(weak, nonatomic) IBOutlet UIButton *track1SoundButton;
@property(weak, nonatomic) IBOutlet UIButton *track2SoundButton;
@property(weak, nonatomic) IBOutlet UIButton *track3SoundButton;
@property(weak, nonatomic) IBOutlet UILabel *track1SoundLabel;
@property(weak, nonatomic) IBOutlet UILabel *track2SoundLabel;
@property(weak, nonatomic) IBOutlet UILabel *track3SoundLabel;

@property AMTrackConfiguration *track1;
@property AMTrackConfiguration *track2;
@property AMTrackConfiguration *track3;

@property NSDate *date;
@property NSArray *arrayOfPlayers;
@property AMSequencer *mainSequencer;

@end

@implementation AMPropertiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSidebarMenu];
    [self loadAppDelegate];
    [self loadMainObjects];
    [self loadTrackConfigurations];
    [self loadColors];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadSidebarMenu {
    SWRevealViewController *revealController = [self revealViewController];
    _navigationBarItem.leftBarButtonItem = [AMVisualUtils createBarButton:@"menu.png"
                                                                   targer:self.revealViewController
                                                                 selector:@selector(revealToggle:)
                                                                     size:26];
    [AMRevealViewUtils initRevealController:revealController
                            withRightButton:nil
                              andLeftButton:_navigationBarItem.leftBarButtonItem];
}

- (void)loadAppDelegate {
    _appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (void)loadMainObjects {
    AMSequencerSingleton *sequencerSingleton = [AMSequencerSingleton sharedSequencer];
    _mainSequencer = sequencerSingleton.sequencer;
    _arrayOfPlayers = _mainSequencer.getArrayOfPlayers;
    _date = [NSDate date];
}

- (void)loadTrackConfigurations {
    _track1 = [[AMTrackConfiguration alloc] initWithLabel:_track1SoundLabel
                                                   button:_track1SoundButton
                                                   slider:_track1Slider
                                                   player:(AMPlayer *) _arrayOfPlayers[0]
                                           viewController:self
                                           soundSegueName:@"sw_track1"
                                           popupSegueName:@"sw_sounds_popup"];
    _track2 = [[AMTrackConfiguration alloc] initWithLabel:_track2SoundLabel
                                                   button:_track2SoundButton
                                                   slider:_track2Slider
                                                   player:(AMPlayer *) _arrayOfPlayers[1]
                                           viewController:self
                                           soundSegueName:@"sw_track2"
                                           popupSegueName:@"sw_sounds_popup"];
    _track3 = [[AMTrackConfiguration alloc] initWithLabel:_track3SoundLabel
                                                   button:_track3SoundButton
                                                   slider:_track3Slider
                                                   player:(AMPlayer *) _arrayOfPlayers[2]
                                           viewController:self
                                           soundSegueName:@"sw_track3"
                                           popupSegueName:@"sw_sounds_popup"];
}

- (void)loadColors {
    UIColor *backgrounColor = [AMAppearanceManager getGlobalColorTheme];
    [self.view setBackgroundColor:backgrounColor];
    [self.navigationController.navigationBar setBarTintColor:backgrounColor];

    UIColor *tintColor = [AMAppearanceManager getGlobalTintColor];
    [self.navigationController.navigationBar setTintColor:tintColor];
    [self.navigationController.navigationItem.backBarButtonItem setTintColor:tintColor];
    [[self.navigationController.navigationBar.subviews lastObject] setTintColor:tintColor];

    [_tintColorButton setTintColor:tintColor];
    [_colorThemeButton setTintColor:tintColor];
    [_resetButton setTintColor:tintColor];
    [_generalSlider setTintColor:tintColor];
}

- (void)loadSliders {
    _generalSlider.value = [_mainSequencer getGlobalVolume];
}

- (void)loadButtons {
    [_tintColorButton setTitle:[[_appDelegate appearanceManager] getGlobalTintColorKey]
                      forState:UIControlStateNormal];
    [_colorThemeButton setTitle:[[_appDelegate appearanceManager] getGlobalColorThemeKey]
                       forState:UIControlStateNormal];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"sw_confirm"]) {
        AMConfirmationViewController *confirmationViewController = (AMConfirmationViewController *) segue.destinationViewController;
        confirmationViewController.delegate = self;
        return;
    }

    if ([segue.identifier isEqualToString:@"sw_sounds_popup"]) {
        AMPopupViewController *popupViewController = (AMPopupViewController *) segue.destinationViewController;
        [popupViewController setText:[AMConfig soundChangeNotAllowed]];
        return;
    }

    UINavigationController *controller = [segue destinationViewController];
    AMSoundsTableViewController *rootController = controller.viewControllers.firstObject;

    if ([[segue identifier] isEqualToString:@"sw_track1"]) {
        [rootController assignPlayer:_arrayOfPlayers[0]];
    }
    if ([[segue identifier] isEqualToString:@"sw_track2"]) {
        [rootController assignPlayer:_arrayOfPlayers[1]];
    }
    if ([[segue identifier] isEqualToString:@"sw_track3"]) {
        [rootController assignPlayer:_arrayOfPlayers[2]];
    }
}

- (IBAction)changeTintColor:(id)sender {
    [[_appDelegate appearanceManager] changeGlobalTintColor];
    [self refreshView];
}


- (IBAction)changeColorTheme:(id)sender {
    [[_appDelegate appearanceManager] changeGlobalColorTheme];
    [self refreshView];
}

- (IBAction)reset:(id)sender {
    [self performSegueWithIdentifier:@"sw_confirm" sender:self];
}

- (void)refreshView {
    [self.tableView reloadData];
    [self refreshTracks];
    [self loadSidebarMenu];
    [self loadColors];
    [self loadButtons];
}

- (void)refreshTracks {
    [_track1 refresh];
    [_track2 refresh];
    [_track3 refresh];
}

- (IBAction)generalTrackVolumeChanged:(id)sender {
    [_mainSequencer setGlobalVolume:_generalSlider.value];
    [self playSound];
}

- (void)playSound {
    AMPlayer *player = (AMPlayer *) _arrayOfPlayers[0];
    NSDate *currentTime = [NSDate date];
    NSTimeInterval timeDifference = [currentTime timeIntervalSinceDate:_date];
    if (timeDifference > 0.8) {
        [player playSound];
        _date = [NSDate date];
    }
}

@end
