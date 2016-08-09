//
//  AboutViewController.m
//  Inclusive U
//
//  Created by Jeremy Thompson on 10/25/15.
//  Copyright © 2015 Jeremy Thompson. All rights reserved.
//
//  Simple About page
//
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (nonatomic, strong) UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set the navbar title
    self.navigationItem.title = @"About";
    UIColor *color = [UIColor colorWithRed:0.75 green:0.34 blue:0.00 alpha:1.0];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //tint the navbar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.2 green:0.247 blue:0.282 alpha:1];
    
    
    self.textView.linkTextAttributes = @{NSForegroundColorAttributeName: color, NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};

}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.textView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
