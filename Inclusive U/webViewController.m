//
//  webViewController.m
//  Inclusive U
//
//  Created by Jeremy Thompson on 12/1/15.
//  Copyright © 2015 Jeremy Thompson. All rights reserved.
//

#import "webViewController.h"
#import "NJKWebViewProgressView.h"
#import "TUSafariActivity.h"

@interface webViewController (){
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@property (nonatomic) IBOutlet UINavigationBar *navbar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) UIActivityViewController *controller;
@property (nonatomic, strong) NSMutableArray *actionSheetItems;
@property (nonatomic, strong) TUSafariActivity *activity;
@end

@implementation webViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Due to the storyboard layout, we need to know what launched this instance of the webViewController
    if (self.isFromLibraries) {
        //set the close button
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:(UIBarButtonSystemItemStop)
                                        target:self
                                        action:@selector(closeViewer:)];
        closeButton.tintColor = [UIColor colorWithRed:0.04 green:0.38 blue:1.00 alpha:1.0];
        self.navbar.topItem.leftBarButtonItem = closeButton;
        
    }else{
        self.navbar = self.navigationController.navigationBar;
    }
    
    
    // Progress Proxy appears at the bottom of the navBar to show website loading progress
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navbar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    self.activity = [[TUSafariActivity alloc] init];
    self.controller = [[UIActivityViewController alloc] initWithActivityItems:@[self.mainURL] applicationActivities:@[self.activity]];
    [self loadSite];
}

- (IBAction)closeViewer:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// This is the share button for sharing the website through default apple sharing locations
- (IBAction)actionButton:(id)sender {
    [self presentViewController:self.controller animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navbar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Remove progress view because UINavigationBar is shared with other ViewControllers
    [_progressView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    self.navbar.topItem.title = @"Inclusive U";
}

// Actually load the site
-(void)loadSite{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:self.mainURL];
    [_webView loadRequest:req];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    [_progressView setProgress:progress animated:YES];
    
    NSString *titleString = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navbar.topItem.title = titleString;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
