//
//  Building.m
//  Inclusive U
//
//  Created by Jeremy Thompson on 8/4/16.
//  Copyright © 2016 Jeremy Thompson. All rights reserved.
//

#import "Building.h"

@interface Building()


@end

@implementation Building

// Default init method (primarily used)
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(id)initWithBasics:(NSString *)buildingName code:(NSString *)buildingCode number:(int)numRestrooms rooms:(NSArray *)roomNumbers address:(NSString *)address longitude:(CGFloat)longitude latitude:(CGFloat)latitude link:(NSURL *)imageLink{
    self = [super init];
    if(self){
        self.bathroomType = @"";
        self.notes = @"";
        self.buildingName = buildingName;
        self.buildingCode = buildingCode;
        self.numRestrooms = numRestrooms;
        self.roomNumbers = roomNumbers;
        self.buildingAddress = address;
        self.longitude = longitude;
        self.latitude = latitude;
        self.imageLink = imageLink;
        
    }
    return self;
}


-(void)prettyPrint{
    NSLog(@"Building name: %@ \n Building code: %@ \nNum Restrooms: %d \nRoom Numbers %@ \nBuilding Address: %@ \nLongitude: %f \nLatitude: %f \nImage Link: %@\n\n", self.buildingName, self.buildingCode, self.numRestrooms, self.roomNumbers, self.buildingAddress, self.longitude, self.latitude, self.imageLink);
}

@end
