//
//  Singleton.m
//  Inclusive U
//
//  Created by Jeremy Thompson on 8/4/16.
//  Copyright © 2016 Jeremy Thompson. All rights reserved.
//

#import "Singleton.h"

@interface Singleton() 
+(Singleton*)singleton;
@end

@implementation Singleton

// Lazy Instantiation to create the singleton
@synthesize buildings;
+(Singleton *)singleton {
    static dispatch_once_t pred;
    static Singleton *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[Singleton alloc] init];
        shared.buildings = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end