//
//  Library.m
//  Inclusive U
//
//  Created by Jeremy Thompson on 8/7/16.
//  Copyright © 2016 Jeremy Thompson. All rights reserved.
//

#import "Library.h"

@implementation Library

// Default init method (primarily used)
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(id)initWithBasics:(NSString *)libraryName longitude:(CGFloat)longitude latitude:(CGFloat)latitude link:(NSURL *)website{
    self = [super init];
    if(self){
        self.libraryName = libraryName;
        self.longitude = longitude;
        self.latitude = latitude;
        self.website = website;
        
    }
    return self;
}

-(void)prettyPrint{
    NSLog(@"Library name: %@ \nLongitude: %f \nLatitude: %f \nWebsite: %@\n\n", self.libraryName, self.longitude, self.latitude, self.website);
}

@end
