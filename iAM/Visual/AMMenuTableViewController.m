//
//  AMMenuTableViewController.m
//  iAM
//
//  Created by Krzysztof Reczek on 16.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMMenuTableViewController.h"
#import "AMMenuToolBarCreator.h"

@interface AMMenuTableViewController ()

@property NSMutableArray *menuItems;

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@property UIBarButtonItem* sequenceButton;
@property UIBarButtonItem* propertiesButton;
@property UIBarButtonItem* aboutButton;

@property (nonatomic) UILabel* sequenceButtonLabel;
@property (nonatomic) UILabel* propertiesButtonLabel;
@property (nonatomic) UILabel* aboutButtonLabel;

@end

@implementation AMMenuTableViewController

static NSString * const reuseIdentifier = @"myMenuStepCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMenuToolBar];
    [self initMocks];
}

- (void)initMenuToolBar{
    AMMenuToolBarCreator *menuToolBarCreator = [[AMMenuToolBarCreator alloc] initWithParent:self];
    _sequenceButtonLabel = [menuToolBarCreator createBarButtonLabelWithText:@"SEQUENCES"
                                                                       font:[UIFont boldSystemFontOfSize:14]
                                                                      color:[UIColor orangeColor]
                                                                    bgColor:[UIColor clearColor]];
    _sequenceButton = [menuToolBarCreator createBarButtonWithLabel:_sequenceButtonLabel
                                                         selector:@selector(sequencesButtonAction)];
    [menuToolBarCreator setSequenceButton:_sequenceButton];
    _propertiesButtonLabel = [menuToolBarCreator createBarButtonLabelWithText:@"PROPERTIES"
                                                                        font:[UIFont boldSystemFontOfSize:14]
                                                                       color:[UIColor grayColor]
                                                                     bgColor:[UIColor clearColor]];
    _propertiesButton = [menuToolBarCreator createBarButtonWithLabel:_propertiesButtonLabel
                                                            selector:@selector(propertiesButtonAction)];
    [menuToolBarCreator setPropertiesButton:_propertiesButton];
    _aboutButtonLabel = [menuToolBarCreator createBarButtonLabelWithText:@"ABOUT"
                                                                   font:[UIFont boldSystemFontOfSize:14]
                                                                  color:[UIColor grayColor]
                                                                bgColor:[UIColor clearColor]];
    _aboutButton = [menuToolBarCreator createBarButtonWithLabel:_aboutButtonLabel
                                                       selector:@selector(aboutButtonAction)];
    [menuToolBarCreator setAboutButton:_aboutButton];
    _toolbar = [menuToolBarCreator getToolBar];
    [self.view addSubview:_toolbar];
    [self sequencesButtonAction];
}

- (void)initMocks{
    _menuItems = [[NSMutableArray alloc] init];
    [_menuItems addObject:@("Sequence 1")];
    [_menuItems addObject:@("Sequence 2")];
    [_menuItems addObject:@("Sequence 3")];
    [_menuItems addObject:@("Sequence 4")];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (void)sequencesButtonAction{
    _sequenceButtonLabel.font = [UIFont boldSystemFontOfSize:14];
    _propertiesButtonLabel.font = [UIFont systemFontOfSize:14];
    _aboutButtonLabel.font = [UIFont systemFontOfSize:14];
    
    _sequenceButtonLabel.textColor = [UIColor orangeColor];
    _propertiesButtonLabel.textColor = [UIColor grayColor];
    _aboutButtonLabel.textColor = [UIColor grayColor];
}

- (void)propertiesButtonAction{
    _sequenceButtonLabel.font = [UIFont systemFontOfSize:14];
    _propertiesButtonLabel.font = [UIFont boldSystemFontOfSize:14];
    _aboutButtonLabel.font = [UIFont systemFontOfSize:14];
    
    _sequenceButtonLabel.textColor = [UIColor grayColor];
    _propertiesButtonLabel.textColor = [UIColor orangeColor];
    _aboutButtonLabel.textColor = [UIColor grayColor];
}

- (void)aboutButtonAction{
    _sequenceButtonLabel.font = [UIFont systemFontOfSize:14];
    _propertiesButtonLabel.font = [UIFont systemFontOfSize:14];
    _aboutButtonLabel.font = [UIFont boldSystemFontOfSize:14];
    
    _sequenceButtonLabel.textColor = [UIColor grayColor];
    _propertiesButtonLabel.textColor = [UIColor grayColor];
    _aboutButtonLabel.textColor = [UIColor orangeColor];
}

@end
