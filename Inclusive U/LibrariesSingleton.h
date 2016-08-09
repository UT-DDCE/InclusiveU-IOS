//
//  LibrariesSingleton.h
//  Inclusive U
//
//  Created by Jeremy Thompson on 8/7/16.
//  Copyright © 2016 Jeremy Thompson. All rights reserved.
//
// Singleton class for the library objects that holds all the buildings after the kml has been parsed
//
//

#import <Foundation/Foundation.h>

@interface LibrariesSingleton : NSObject

// Singleton object
+(LibrariesSingleton*)singleton;

// Array of library objects in the singleton
@property (nonatomic, retain) NSMutableArray *libraries;
@end
