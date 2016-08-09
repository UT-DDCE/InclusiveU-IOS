//
//  PartnersViewController.m
//  Inclusive U
//
//  Created by Jeremy Thompson on 10/25/15.
//  Copyright © 2015 Jeremy Thompson. All rights reserved.
//
//  Basically just a bunch of button links to open
//
//

#import "PartnersViewController.h"

@interface PartnersViewController ()
@property (nonatomic, strong) UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewInside;

@end

@implementation PartnersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set the navbar title
    self.navigationItem.title = @"Partners";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //tint the navbar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.2 green:0.247 blue:0.282 alpha:1];
}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = self.viewInside.bounds.size;
}

- (IBAction)gscButton:(id)sender {
    NSURL *link = [NSURL URLWithString:@"http://ddce.utexas.edu/genderandsexuality/"];
    [[UIApplication sharedApplication] openURL:link];
}

- (IBAction)ddceButton:(id)sender {
    NSURL *link = [NSURL URLWithString:@"http://www.utexas.edu/diversity/"];
    [[UIApplication sharedApplication] openURL:link];
}

- (IBAction)utLibButton:(id)sender {
    NSURL *link = [NSURL URLWithString:@"http://www.lib.utexas.edu/"];
    [[UIApplication sharedApplication] openURL:link];
}

- (IBAction)ssdButton:(id)sender {
    NSURL *link = [NSURL URLWithString:@"http://ddce.utexas.edu/disability/"];
    [[UIApplication sharedApplication] openURL:link];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
