//
//  AMMenuViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 10.06.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMMenuViewController.h"

@interface AMMenuViewController () {
    UIView *_actualView;
}

@end

@implementation AMMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initContainer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initContainer {
}

- (IBAction)onGridButton:(id)sender {
}

- (IBAction)onSequencesButton:(id)sender {
    [self switchStoryBoardWithIdentifier:@"v_sequences"];
}

- (IBAction)onPropertiesButton:(id)sender {
    [self switchStoryBoardWithIdentifier:@"v_properties"];
}

- (IBAction)onAboutButton:(id)sender {
    [self switchStoryBoardWithIdentifier:@"v_about"];
}

- (void)switchStoryBoardWithIdentifier:(NSString *)identifier {
    [_viewContainer setAutoresizesSubviews:YES];
    if(_actualView!=nil){
        [_actualView removeFromSuperview];
    }
    _actualView = [[self.storyboard instantiateViewControllerWithIdentifier:identifier] view];
    _actualView.frame = _viewContainer.bounds;
    [_viewContainer addSubview:_actualView];
}

@end
