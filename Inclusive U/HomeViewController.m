//
//  HomeViewController.m
//  Inclusive U
//
//  Created by Jeremy Thompson on 10/25/15.
//  Copyright © 2015 Jeremy Thompson. All rights reserved.
//

#import "HomeViewController.h"
#import "KML.h"
#import "Reach.h"
#import "Building.h"
#import "Library.h"
#import "Singleton.h"
#import "LibrariesSingleton.h"
#import "MapViewController.h"
#import "webViewController.h"

@interface HomeViewController (){
    Reach *internetReachableFoo;
}
@property NSString *restroomFileName;
@property NSString *restroomFileType;
@property NSString *librariesFileName;
@property NSString *librariesFileType;
@property (weak, nonatomic) IBOutlet UIButton *restroomsMapButton;
@property (weak, nonatomic) IBOutlet UIButton *librariesMapButton;


@end

@implementation HomeViewController

#pragma mark Enum stuff
// Simple ENUM for parsing the building kml info

//Building Name,Building Code,Room Numbers,Bathroom type,floor,Building Address,Latitude,Longitude,notes
enum {
    KMLBuildingCode = 0,
    KMLRoomNumbers = 1,
    KMLBathroomType = 2,
    KMLNumRooms = 3,
    KMLBuildingAddress = 4,
    KMLLatitude = 5,
    KMLLongitude = 6,
    KMLNotes = 7,
    KMLImageLink = 8
};
#define kmlString(enum) [@[@"Building Code",@"Room Numbers", @"Bathroom type", @"Num Rooms", @"Building Address", @"Latitude", @"Longitude", @"Notes", @"gx_media_links"] objectAtIndex:enum]

// Set the Nav Controller title
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"Inclusive U";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Disable the map buttons until the parsing is finished
    self.restroomsMapButton.enabled = NO;
    self.librariesMapButton.enabled = NO;
    
    // Set the filenames and types for the kml files
    self.restroomFileName = @"Gender Inclusive Restrooms";
    self.restroomFileType = @"kml";
    self.librariesFileName = @"UT Libraries Map";
    self.librariesFileType = @"kml";
    
    // Set a white tint for items on the navbar
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //tint the navbar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.2 green:0.247 blue:0.282 alpha:1];
    
    // Copy the resource files over so that we have a location for the downloaded version.
    [self copyResourceFilesOver];
    
    // If Internet then download newest file, else use version on the app
    [self testInternetConnection];
}


-(void)copyResourceFilesOver{
    // Grab the different possible directories paths
    NSArray  *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Use the first one as a Documents Directory
    NSString *documentsDir = dirPaths[0];
    
    // Create the filepath for the file I want to move
    NSString *restroomsKMLPath = [documentsDir stringByAppendingString:@"/Gender Inclusive Restrooms.kml"];
    NSString *librariesKMLPath = [documentsDir stringByAppendingString:@"/UT Libraries Map.kml"];
    
    // Grab the default file manager
    NSFileManager *fm = [NSFileManager defaultManager];
    
    
    // Check whether the restroom kml file was moved earlier
    if(![fm fileExistsAtPath:restroomsKMLPath]) {
        NSError *error;
        NSString *bundledRestroomsKMLFile = [[NSBundle mainBundle] pathForResource:@"Gender Inclusive Restrooms" ofType:@"kml"];
        [fm copyItemAtPath:bundledRestroomsKMLFile toPath:restroomsKMLPath error:&error];
        if (error) {
            NSLog(@"%@", error);
        }else{ NSLog(@"Copied Successfully"); }
    }else{ NSLog(@"No need to copy"); }
    
    // Check whether the library kml file was moved earlier
    if(![fm fileExistsAtPath:librariesKMLPath]) {
        NSError *error;
        NSString *bundledLibrariesKMLFile = [[NSBundle mainBundle] pathForResource:@"UT Libraries Map" ofType:@"kml"];
        [fm copyItemAtPath:bundledLibrariesKMLFile toPath:librariesKMLPath error:&error];
        if (error) {
            NSLog(@"%@", error);
        }else{ NSLog(@"Copied Successfully"); }
    }else{ NSLog(@"No need to copy"); }
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

-(void)ifInternet{
    // URL of the custom map for restrooms
    NSString *restroomsMapURL = @"http://www.google.com/maps/d/u/0/kml?forcekml=1&mid=1lA-3jWjNar_DWJsmYojIXn5-ZNw&lid=zBbV9mY1BsPw.kVFvjEqElAK0";
    NSURL *restroomsKMLURL = [NSURL URLWithString:restroomsMapURL];
    
    NSURLSessionTask *restroomDownloadTask = [[NSURLSession sharedSession] dataTaskWithURL:restroomsKMLURL completionHandler:^(NSData * _Nullable data,NSURLResponse * _Nullable response, NSError * _Nullable error){
        if (!error) {
            
            // Grab the different possible directories paths
            NSArray  *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            // Use the first one as a Documents Directory
            NSString *documentsDir = dirPaths[0];
            
            // Create the filepath for the file I want to write/overwrite
            NSString *restroomsKMLPath = [documentsDir stringByAppendingString:[NSString stringWithFormat:@"/%@.%@", self.restroomFileName, self.restroomFileType]];
            
            // Grab the default file manager
            NSFileManager *fm = [NSFileManager defaultManager];
            
            
            // Write the file
            BOOL result = [fm createFileAtPath:restroomsKMLPath contents:data attributes:@{NSFileCreationDate: [NSDate date], NSFileImmutable: @NO} ];
            if (result) {
                [self parseRestroomKML];
            }else{ NSLog(@"It didn't write"); }
        }
    }];
    
    // Libraries Map link:
    NSString *librariesURL = @"https://www.google.com/maps/d/u/0/kml?forcekml=1&mid=1bqRbBRb_yi_nPG_uxn6hCQ8sBTI";
    NSURL *librariesKMLURL = [NSURL URLWithString:librariesURL];
    
    NSURLSessionTask *librariesDownloadTask = [[NSURLSession sharedSession] dataTaskWithURL:librariesKMLURL completionHandler:^(NSData * _Nullable data,NSURLResponse * _Nullable response, NSError * _Nullable error){
        if (!error) {
            
            // Grab the different possible directories paths
            NSArray  *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            // Use the first one as a Documents Directory
            NSString *documentsDir = dirPaths[0];
            
            // Create the filepath for the file I want to write/overwrite
            NSString *restroomsKMLPath = [documentsDir stringByAppendingString:[NSString stringWithFormat:@"/%@.%@", self.librariesFileName, self.librariesFileType]];
            
            // Grab the default file manager
            NSFileManager *fm = [NSFileManager defaultManager];
            
            
            // Write the file
            BOOL result = [fm createFileAtPath:restroomsKMLPath contents:data attributes:@{NSFileCreationDate: [NSDate date], NSFileImmutable: @NO} ];
            if (result) {
                [self parseLibrariesKML];
            }else{ NSLog(@"It didn't write"); }
        }
    }];
    
    // Start the download and file write
    [restroomDownloadTask resume];
    [librariesDownloadTask resume];
}

// The whole point of downloading and storing the kml files is to be able to show data even when internet is spotty. Parse anyway.
-(void)ifNotInternet{
    [self parseRestroomKML];
    [self parseLibrariesKML];
}

- (void)parseRestroomKML{
    // Create queue to run on
    dispatch_queue_t loadKmlQueue = dispatch_queue_create("queue", NULL);
    
    // Grab the directory path for the file to parse from
    NSArray  *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = dirPaths[0];
    NSString *restroomsKMLPath = [documentsDir stringByAppendingString:[NSString stringWithFormat:@"/%@.%@", self.restroomFileName, self.restroomFileType]];
    NSURL *url = [NSURL fileURLWithPath:restroomsKMLPath];
    
    __weak typeof(self) weakSelf = self;
    
    // Launch the queue parser
    dispatch_async(loadKmlQueue, ^{
        KMLRoot *newKml = [KMLParser parseKMLAtURL:url];
        
        // Placemarks are the different markers from the map
        NSArray *placemarks = [newKml placemarks];
        
        // Loop through the markers and extract the info
        for (int j = 0; j < [placemarks count]; j++) {
            KMLPlacemark *p = [placemarks objectAtIndex:j];
            KMLExtendedData *extendedData = p.extendedData;
            NSArray *dataList = [extendedData dataList];
            
            Building *building = [[Building alloc] init];
            building.buildingName = p.name;
            
            NSString *seperators = @",";
            NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:seperators];
            for (int i = 0; i < [dataList count]; i++) {
                KMLData *data = [dataList objectAtIndex:i];
                if ([data.name isEqualToString:kmlString(KMLBuildingCode)]) { building.buildingCode = data.value; }
                else if ([data.name isEqualToString:kmlString(KMLRoomNumbers)]) {
                    NSArray *rooms = [data.value componentsSeparatedByCharactersInSet:set];
                    building.roomNumbers = rooms;   }
                else if ([data.name isEqualToString:kmlString(KMLBuildingAddress)]) { building.buildingAddress = data.value; }
                else if ([data.name isEqualToString:kmlString(KMLBathroomType)]) { building.bathroomType = data.value; }
                else if ([data.name isEqualToString:kmlString(KMLLatitude)]) { building.latitude = data.value.floatValue; }
                else if ([data.name isEqualToString:kmlString(KMLLongitude)]) { building.longitude = data.value.floatValue; }
                else if ([data.name isEqualToString:kmlString(KMLImageLink)]) { building.imageLink = [NSURL URLWithString: data.value]; }
            }
            building.numRestrooms = (int)[building.roomNumbers count];
            [[Singleton singleton].buildings addObject:building];
        }
        NSLog(@"Done");
        weakSelf.restroomsMapButton.enabled = YES;
    });
}

- (void)parseLibrariesKML{
    // Create queue to run on
    dispatch_queue_t loadKmlQueue = dispatch_queue_create("queue", NULL);
    
    // Grab the directory path for the file to parse from
    NSArray  *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = dirPaths[0];
    NSString *libraryKMLPath = [documentsDir stringByAppendingString:[NSString stringWithFormat:@"/%@.%@", self.librariesFileName, self.librariesFileType]];
    NSURL *url = [NSURL fileURLWithPath:libraryKMLPath];
    
    __weak typeof(self) weakSelf = self;
    
    // Launch the queue parser
    dispatch_async(loadKmlQueue, ^{
        KMLRoot *newKml = [KMLParser parseKMLAtURL:url];
        
        // Placemarks are the different markers from the map
        NSArray *placemarks = [newKml placemarks];
        
        // Loop through the markers and extract the info
        for (int j = 0; j < [placemarks count]; j++) {
            KMLPlacemark *p = [placemarks objectAtIndex:j];
            KMLExtendedData *extendedData = p.extendedData;
            NSArray *dataList = [extendedData dataList];
            Library *library = [[Library alloc] init];
            library.libraryName = p.name;
            
            for (int i = 0; i < [dataList count]; i++) {
                KMLData *data = [dataList objectAtIndex:i];
                if ([data.name isEqualToString:@"URL"]) {   library.website = [NSURL URLWithString:data.value];  }
                else if ([data.name isEqualToString:@"Latitude"]){  library.latitude = data.value.floatValue;   }
                else if ([data.name isEqualToString:@"Longitude"]){  library.longitude = data.value.floatValue;   }
            }
            [[LibrariesSingleton singleton].libraries addObject:library];
        }
        NSLog(@"Done");
        weakSelf.librariesMapButton.enabled = YES;
    });
}

// Open the I'll Go With You button link
- (IBAction)illGoWithYou:(id)sender {
    NSURL *link = [NSURL URLWithString:@"http://www.illgowithyou.org/"];
    [[UIApplication sharedApplication] openURL:link];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if ([segue.identifier isEqualToString:@"ShowLibrarySpecialists"]) {
        
        // If true then set the webvew info
        if ([segue.destinationViewController class] == [webViewController class]) {
            webViewController *wvc = segue.destinationViewController;
            NSURL *url = [NSURL URLWithString:@"https://www.lib.utexas.edu/subject/index.php"];
            wvc.mainURL = url;
        }
    }
}


@end