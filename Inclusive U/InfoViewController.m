//
//  InfoViewController.m
//  PDF_Testing
//
//  Created by Jeremy Thompson on 8/6/15.
//  Copyright (c) 2015 Jeremy Thompson. All rights reserved.
//

#import "InfoViewController.h"
#import "ImageViewer.h"
#import "Reach.h"
#import "PINImageView+PINRemoteImage.h"
#import <PINCache/PINCache.h>

@interface InfoViewController (){
    Reach *internetReachableFoo;

}

@property (weak, nonatomic) IBOutlet UILabel *noImageLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBarItem;
@property (weak, nonatomic) IBOutlet UIImageView *buildingImage;
@property (nonatomic, strong) NSString *docTitle;
@property (strong) ImageViewer *imageViewer;
@property (strong) NSString *buildingCode;
@end

@implementation InfoViewController

#pragma mark TableView Methods

// Table that displays the room numbers of the buildings and the building code
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomNumberCell" forIndexPath:indexPath];

    cell.textLabel.text = [self.infoBuilding.roomNumbers objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = self.buildingCode;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}


#pragma mark TableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoBuilding.numRestrooms;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark Class Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set the close button
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:(UIBarButtonSystemItemStop)
                                    target:self
                                    action:@selector(doneButtonTapped)];
    closeButton.tintColor = [UIColor colorWithRed:0.04 green:0.38 blue:1.00 alpha:1.0];
    self.navBarItem.leftBarButtonItem = closeButton;
    
    //set the building code
    self.buildingCode = self.infoBuilding.buildingCode;

    //set the image
    [self testInternetConnection];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageWasTapped)];
    self.buildingImage.userInteractionEnabled = TRUE;
    [self.buildingImage addGestureRecognizer:tapped];
    
}

// If there is internet and there is a link available, download and show it, otherwise remove the image and show the correct message (from the Storyboard)
-(void)ifInternet{
    if (self.infoBuilding.imageLink) {
        [self.noImageLabel removeFromSuperview];
        [self.buildingImage pin_setImageFromURL:self.infoBuilding.imageLink completion:^(PINRemoteImageManagerResult * _Nonnull result) {
            [self.imageLabel removeFromSuperview];
        }];
    }else{
        [self.imageLabel removeFromSuperview];
    }
}

// If no internet then remove the noImageLabel and show the no internet message
-(void)ifNotInternet{
    self.imageLabel.text = @"No Internet Access";
    [self.noImageLabel removeFromSuperview];
}


// Checks if we have an internet connection or not
- (void)testInternetConnection{
    internetReachableFoo = [Reach reachabilityWithHostname:@"www.google.com"];
    
    __weak __typeof__(self) weakSelf = self;
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reach *reach){
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf ifInternet];
            NSLog(@"Yayyy, we have the interwebs!");
        });
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reach *reach){
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf ifNotInternet];
            NSLog(@"Someone broke the internet :(");
        });
    };
    
    [internetReachableFoo startNotifier];
}

// It's closing time... One last call for alcohol
-(void)doneButtonTapped{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

// If the image was tapped then pop it into its own screen that will allow for zooming
-(void)imageWasTapped{
    self.imageViewer = [[ImageViewer alloc] initWithViewAndImage:self image:self.buildingImage.image];
    [self.imageViewer setUpImageAndScrollview];
}

// If the directions button is pressed then open maps and get directions to the building
- (IBAction)directionsButtonPressed:(id)sender {
    NSString *address = self.infoBuilding.buildingAddress;
    
    NSArray *addressParts = [address componentsSeparatedByString:@", "];

    NSString *baseURlGoogleMaps = @"comgooglemaps://";
    NSString *baseURlAppleMaps = @"http://maps.apple.com/?";
    NSString *directionsMode = @"&directionsmode=walking";

    NSString *addressURLGoogle = [NSString stringWithFormat:@"%@?q=%@,%@%@",
                            baseURlGoogleMaps,
                            [addressParts[0] stringByReplacingOccurrencesOfString:@" " withString:@"+"],
                            [addressParts[1] stringByReplacingOccurrencesOfString:@" " withString:@"+"],
                            directionsMode
    ];
    
    NSString *addressURLApple = [NSString stringWithFormat:@"%@q=%@,%@",
                                  baseURlAppleMaps,
                                  [addressParts[0] stringByReplacingOccurrencesOfString:@" " withString:@"+"],
                                  [addressParts[1] stringByReplacingOccurrencesOfString:@" " withString:@"+"]
                                  ];
    
    
    // We prefer google maps so we try that first, if it's not installed then use apple maps
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:baseURlGoogleMaps]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:addressURLGoogle]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:addressURLApple]];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarItem.title = self.infoBuilding.buildingName;
}

// Things necessary to make it look good
-(void)viewDidLayoutSubviews{
    CGSize content = self.tableView.contentSize;
    CGRect tableFrame = [self.tableView frame];
    
    if (content.height > 176) {
        tableFrame = CGRectMake(self.tableView.frame.origin.x,
                                self.tableView.frame.origin.y,
                                self.tableView.frame.size.width, 195);
    }else{
        tableFrame = CGRectMake(self.tableView.frame.origin.x,
                                self.tableView.frame.origin.y,
                                self.tableView.frame.size.width,
                                self.tableView.contentSize.height);
        self.tableView.scrollEnabled = NO;
    }
    
    self.tableView.frame = tableFrame;
    
    CGFloat maxImageHeight = [[UIScreen mainScreen] bounds].size.height - 8 - (self.tableView.frame.origin.y + self.tableView.frame.size.height + 12);
    
    
    if (maxImageHeight > self.buildingImage.frame.size.width) {
        maxImageHeight = self.buildingImage.frame.size.width;
        
        self.buildingImage.frame = CGRectMake(self.buildingImage.frame.origin.x,
                                              [[UIScreen mainScreen] bounds].size.height - 8 - maxImageHeight,
                                              self.buildingImage.frame.size.width,
                                              maxImageHeight);
    }else{
        self.buildingImage.frame = CGRectMake(self.buildingImage.frame.origin.x,
                                              self.tableView.frame.origin.y + self.tableView.frame.size.height + 8,
                                              self.buildingImage.frame.size.width,
                                              maxImageHeight);
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
