//
//  MapViewController.m
//  Inclusive U
//
//  Created by Jeremy Thompson on 10/25/15.
//  Copyright © 2015 Jeremy Thompson. All rights reserved.
//

#import "MapViewController.h"
#import "PreviewWindow.h"
#import "InfoViewController.h"
#import "Singleton.h"
#import "Building.h"

@import GoogleMaps;

@interface MapViewController () <CLLocationManagerDelegate, GMSMapViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIBarButtonItem *menuButton;
@property (nonatomic, strong) CLLocationManager *manager;
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic) BOOL previewShowing;
@property (nonnull, strong) Building *infoBuilding;

@end

@implementation MapViewController{
    NSMutableArray *currentRow;
    NSMutableDictionary *dict;
    PreviewWindow *previewWindow;
    UIEdgeInsets previewWindowInsets;
    UIEdgeInsets noInsets;
}

#pragma mark Initialization methods

// Lazy Instantiate the location manager
-(instancetype)init{
    if (!self) {
        if (!_manager) {
            _manager = [[CLLocationManager alloc] init];
            _manager.delegate = self;
        }
    }
    return self;
}

// Check that we have permissions and start updating location
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

    
    //set the navbar title
    self.navigationItem.title = @"Campus Map";
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
    
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.mapType = kGMSTypeHybrid;
    self.mapView.indoorEnabled = YES;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.view = _mapView;
    self.mapView.delegate = self;
    
    // Grab the info necessary for the marker from the buildings and then add the building to userData for use later
    NSMutableArray *buildings = [Singleton singleton].buildings;
    for (int i = 0; i < [buildings count]; i++) {
        Building *b = [buildings objectAtIndex:i];
        GMSMarker *marker = [GMSMarker new];
        double latitude = b.latitude;
        double longitude = b.longitude;
        NSString *buildingName = b.buildingName;
        marker.position = CLLocationCoordinate2DMake(latitude, longitude);
        marker.title = buildingName;
        marker.userData = b;
        marker.map = self.mapView;
    }
    
    [self makeThePreviewWindow];
}

#pragma mark Preview and Info windows

// This is the preview window which will show up at the bottom of the screen when a marker is tapped
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

// Whenever a marker is tapped, make a preview window and this populates it with the building's full name
-(void)populatePreviewWindow:(GMSMarker *)marker{
    Building *temp = marker.userData;

    NSString *bn = temp.buildingName;
    previewWindow.buildingNameLabel.text = [NSString stringWithFormat:@"%@", bn];
    
    previewWindow.seeMoreLabel.text = [NSString stringWithFormat:@"See room number(s)"];
    previewWindow.seeMoreLabel.textColor = [UIColor colorWithRed:0.502 green:0.741 blue:1 alpha:1];
    self.infoBuilding = temp;
}

// This cleans the preview window of info to make it easier for the next building to show
-(void)cleanPreviewWindow{
    previewWindow.buildingNameLabel.text = nil;
    previewWindow.seeMoreLabel.text = nil;
    self.infoBuilding = [Building new];
}

// Whenever the preview window is tapped, we need to present the InfoViewController and pass the info to that
-(void)presentMoreInfo{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoViewController *info = [board instantiateViewControllerWithIdentifier:@"infoViewController"];
    info.infoBuilding = self.infoBuilding;
    [self presentViewController:info animated:YES completion:^{
        info.infoBuilding = self.infoBuilding;
    }];
}

// This detects that the preview window was touched
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self presentMoreInfo];
}


#pragma mark Map Delegate methods

// This is the method that is ran whenever a marker is tapped.
-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    if (!self.previewShowing) {
        self.previewShowing = !self.previewShowing;
    }
    
    // Clean the preview window and then populate with the marker
    [self cleanPreviewWindow];
    [self populatePreviewWindow:marker];
    
    // Animate the preview window into view
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.mapView.padding = previewWindowInsets;
                     }
                     completion:^(BOOL finished){
                     }];
    
    [self.view addSubview:previewWindow];
    self.previewShowing = true;
    return nil;
}

// If you tap somewhere on the map while a preview window is showing, then it needs to animate off screen
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    if (self.previewShowing) {
        [previewWindow removeFromSuperview];
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.mapView.padding = noInsets;
                         }
                         completion:^(BOOL finished){
                             //NSLog(@"Done!");
                         }];
        self.previewShowing = !self.previewShowing;
    }
}


#pragma mark Useless

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
