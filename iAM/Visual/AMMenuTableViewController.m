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

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation AMMenuTableViewController

static NSString * const reuseIdentifier = @"myMenuStepCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMenuItems];
    [self initMenuToolBar];
    [self initMenuToolBarComponents];
}

- (void)initMenuItems{
    _menuItems = [[NSMutableArray alloc] init];
    [_menuItems addObject:@("Sequence 1")];
    [_menuItems addObject:@("Sequence 2")];
    [_menuItems addObject:@("Sequence 3")];
    [_menuItems addObject:@("Sequence 4")];
}

- (void)initMenuToolBar{
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(_mainView.frame.size.height/2*-1 + 20,
                                                           _mainView.frame.size.height/2 - 20,
                                                           _mainView.frame.size.height,
                                                           40)];
    _toolbar.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/2);
    _toolbar.barTintColor = [UIColor blackColor];
    [self.view addSubview:_toolbar];
}

- (void)initMenuToolBarComponents{
    NSArray *buttons = [NSArray arrayWithObjects: [self createBarFlexibleSpace],
                        [self createBarButtonWithPictureName:@"seq2.png"
                                                    selector:@selector(sequencesButtonAction)
                                                        size:30
                                                       color:[UIColor orangeColor]],
                        [self createBarFlexibleSpace],
                        [self createBarButtonWithPictureName:@"seq2.png"
                                                    selector:@selector(propertiesButtonAction)
                                                        size:30
                                                       color:[UIColor grayColor]],
                        [self createBarFlexibleSpace],
                        [self createBarButtonWithPictureName:@"seq2.png"
                                                    selector:@selector(aboutButtonAction)
                                                        size:30
                                                       color:[UIColor grayColor]],
                        [self createBarFlexibleSpace], nil];
    [_toolbar setItems: buttons animated:NO];
}

- (UIBarButtonItem*)createBarButtonWithPictureName: (NSString *)pictureName
                                        selector: (SEL)selector
                                            size: (NSInteger)size
                                           color: (UIColor*)color{
    UIImage *faceImage = [[UIImage imageNamed:pictureName]
                          imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.tintColor = color;
    face.bounds = CGRectMake( size, size, size, size );
    [face setImage:faceImage
          forState:UIControlStateNormal];
    [face addTarget:self
             action:selector
   forControlEvents:UIControlEventTouchDown];
    
    return [[UIBarButtonItem alloc] initWithCustomView:face];
}

- (UIBarButtonItem*)createBarFlexibleSpace{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                         target:nil
                                                         action:nil];
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

- (void)sequencesButtonAction{
    
}

- (void)propertiesButtonAction{
    
}

- (void)aboutButtonAction{
    
}

@end
