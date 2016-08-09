//
//  LibrariesSingleton.m
//  Inclusive U
//
//  Created by Jeremy Thompson on 8/7/16.
//  Copyright © 2016 Jeremy Thompson. All rights reserved.
//

#import "LibrariesSingleton.h"

@interface LibrariesSingleton()
+(LibrariesSingleton* )singleton;
@end

@implementation LibrariesSingleton

// Lazy Instantiation to create the singleton
@synthesize libraries;
+(LibrariesSingleton *)singleton {
    static dispatch_once_t pred;
    static LibrariesSingleton *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[LibrariesSingleton alloc] init];
        shared.libraries = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
