//
//  LibraryMapViewController.m
//  Inclusive U
//
//  Created by Jeremy Thompson on 12/2/15.
//  Copyright © 2015 Jeremy Thompson. All rights reserved.
//
//  This is identical to the MapViewController, just for the libraries
//
//

#import "LibraryMapViewController.h"
#import "PreviewWindow.h"
#import "webViewController.h"
#import "LibrariesSingleton.h"
#import "Library.h"

@import GoogleMaps;

@interface LibraryMapViewController () <GMSMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic) BOOL previewShowing;
@property (nonatomic, strong) NSDictionary *infoDict;
@property (nonatomic) Library *infoLib;

@end

@implementation LibraryMapViewController{
    GMSMapView *mapView_;
    NSMutableArray *currentRow;
    NSMutableDictionary *dict;
    PreviewWindow *previewWindow;
    UIEdgeInsets previewWindowInsets;
    UIEdgeInsets noInsets;
}

// Lazy instantiate the location manager
-(instancetype)init{
    if (!self) {
        if (!_manager) {
            _manager = [[CLLocationManager alloc] init];
            _manager.delegate = self;
        }
    }
    return self;
}

// Start updating if we have permissions
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.manager startUpdatingLocation];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //location!
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.manager requestWhenInUseAuthorization];
    }
    
    self.navigationItem.leftBarButtonItem = self.menuButton;
    self.navigationItem.title = @"UT Libraries";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //tint the navbar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.2 green:0.247 blue:0.282 alpha:1];

    
    //Map!
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate 30.28595,-97.737183 at zoom level 16.
    // This is centered at UT Austin
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:30.285925
                                                            longitude:-97.737183
                                                                 zoom:16];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.mapType = kGMSTypeHybrid;
    mapView_.indoorEnabled = YES;
    mapView_.myLocationEnabled = YES;
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
    self.view = mapView_;
    mapView_.delegate = self;
    
    // Make the markers
    // Loop through the libraries and get the relevant info for the markers. Add the library object to userData for use later
    NSArray *libraries = [LibrariesSingleton singleton].libraries;
    for (int j = 0; j < [libraries count]; j++) {
        Library *lib = [libraries objectAtIndex:j];
        GMSMarker *marker = [GMSMarker new];
        double latitude = lib.latitude;
        double longitude = lib.longitude;
        NSString *libName = lib.libraryName;
        marker.position = CLLocationCoordinate2DMake(latitude, longitude);
        marker.title = libName;
        marker.userData = lib;
        marker.map = mapView_;
    }

    [self makeThePreviewWindow];
}

#pragma mark Preview and Info windows

// Creation of the preview window
-(void)makeThePreviewWindow{
    CGRect applicationFrame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 60, [UIScreen mainScreen].bounds.size.width, 60);
    previewWindow = [[PreviewWindow alloc] initWithFrame:applicationFrame];
    previewWindow.userInteractionEnabled = TRUE;
    previewWindow.buildingNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, previewWindow.bounds.size.width, 20)];
    previewWindow.seeMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, previewWindow.bounds.size.width, 20)];
    previewWindow.seeMoreLabel.textAlignment = NSTextAlignmentCenter;
    previewWindow.buildingNameLabel.textAlignment = NSTextAlignmentCenter;
    [previewWindow addSubview:previewWindow.buildingNameLabel];
    [previewWindow addSubview:previewWindow.seeMoreLabel];
    
    //color the window
    previewWindow.backgroundColor = [UIColor colorWithRed:0.2 green:0.247 blue:0.282 alpha:1];
    previewWindow.buildingNameLabel.textColor = [UIColor whiteColor];
    
    previewWindowInsets = UIEdgeInsetsMake(0.0, 0.0, 60.0, 0.0);
    noInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

// Populating the preview window with the name of the library and a message
-(void)populatePreviewWindow:(GMSMarker *)marker{
    Library *lib = marker.userData;
    
    previewWindow.buildingNameLabel.text = lib.libraryName;
    
    previewWindow.seeMoreLabel.text = [NSString stringWithFormat:@"Go To Website"];
    previewWindow.seeMoreLabel.textColor = [UIColor colorWithRed:0.502 green:0.741 blue:1 alpha:1];
    
    self.infoLib = lib;
}

// Clean the preview window to make it clean and easier for use by the next library
-(void)cleanPreviewWindow{
    previewWindow.buildingNameLabel.text = nil;
    previewWindow.seeMoreLabel.text = nil;
    self.infoLib = [Library new];
}

// Preview window was tapped so load the webViewController and launch the website for that library
-(void)presentMoreInfo{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    webViewController *info = [board instantiateViewControllerWithIdentifier:@"webViewControllerLib"];
    info.mainURL = self.infoLib.website;
    NSLog(@"website: %@", self.infoLib.website);
    info.isFromLibraries = YES;
    info.buildingName = self.infoLib.libraryName;
    [self presentViewController:info animated:YES completion:nil];
}

// Touch detection, show the website
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self presentMoreInfo];
}


#pragma mark Map Delegate methods

// Marker was tapped, animate the preview window onto screen
-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    if (!self.previewShowing) {
        self.previewShowing = !self.previewShowing;
    }
    
    [self cleanPreviewWindow];
    [self populatePreviewWindow:marker];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         mapView_.padding = previewWindowInsets;
                     }
                     completion:^(BOOL finished){
                     }];
    
    [self.view addSubview:previewWindow];
    self.previewShowing = true;
    return nil;
}

// Empty map was tapped, animate the preview window off the screen
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    if (self.previewShowing) {
        [previewWindow removeFromSuperview];
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             mapView_.padding = noInsets;
                         }
                         completion:^(BOOL finished){
                         }];
        self.previewShowing = !self.previewShowing;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
