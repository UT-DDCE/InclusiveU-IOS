//
//  DevelopmentViewController.m
//  Inclusive U
//
//  Created by Jeremy Thompson on 11/4/15.
//  Copyright © 2015 Jeremy Thompson. All rights reserved.
//

#import "DevelopmentViewController.h"

@interface DevelopmentViewController ()
@property (nonatomic, strong) UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UITextView *developerTextView;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;

@end

@implementation DevelopmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.developerTextView.delegate = self;
    
    UIColor *color = [UIColor colorWithRed:0.75 green:0.34 blue:0.00 alpha:1.0];

    
    //set the navbar title
    self.navigationItem.title = @"Development";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //tint the navbar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.2 green:0.247 blue:0.282 alpha:1];
    
    // This is literally all just to add a hyperlink in the middle of the string. 
    
    // Setup the text and the url to add
    NSString *string = @"The Inclusive U app was developed by Jeremy Thompson, with the Android version modeled after this one developed by Connor White.";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange subString = [string rangeOfString:@"Jeremy Thompson"];
    NSURL *linkURL = [NSURL URLWithString:@"http://www.mrjeremyt.com"];
    
    // Set the different attributes of the attributed string.
    [attributedString beginEditing];
    
    // Set the font style and size of the string
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, string.length)];
    
    // Set the link for the specified range established previously
    [attributedString addAttribute:NSLinkAttributeName value:linkURL range:subString];

    // Set the link to have an underline to emphasize that it's a link
    [attributedString addAttribute:NSUnderlineStyleAttributeName
                             value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                             range:subString];
    
    [attributedString endEditing];
    
    
    // set the text view to be the attributed text string.
    self.developerTextView.attributedText = attributedString;
    
    // set the link-detection color
    self.developerTextView.linkTextAttributes = @{NSForegroundColorAttributeName: color, NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    self.feedbackTextView.linkTextAttributes = @{NSForegroundColorAttributeName: color, NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
}


// Have iOS open the link when clicked
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    return YES; // Return NO if you don't want iOS to open the link
}

- (IBAction)feedbackFormButton:(id)sender {
    NSURL *link = [NSURL URLWithString:@"https://utexas.qualtrics.com/jfe/form/SV_b1aDEH4P4vFPUEZ"];
    [[UIApplication sharedApplication] openURL:link];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
