//
//  Singleton.h
//  Inclusive U
//
//  Created by Jeremy Thompson on 8/4/16.
//  Copyright © 2016 Jeremy Thompson. All rights reserved.
//
//
// Singleton class for the restrooms Building objects that holds all the buildings after the kml has been parsed
//
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject

// Singleton object
+(Singleton*)singleton;

// Array of building objects accessed from the singleton
@property (nonatomic, retain) NSMutableArray *buildings;

@end
