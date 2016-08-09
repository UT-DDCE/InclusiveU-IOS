//
//  Library.h
//  Inclusive U
//
//  Created by Jeremy Thompson on 8/7/16.
//  Copyright © 2016 Jeremy Thompson. All rights reserved.
//
// Library class representing campus libraries and the info for it
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Library : NSObject

// Custom initialization method provided you already have the proper components
-(id)initWithBasics:(NSString *)libraryName longitude:(CGFloat)longitude latitude:(CGFloat)latitude link:(NSURL *)website;

// Function for printing out a building (and looking structured)
-(void)prettyPrint;

// Publicly accessible properties
@property NSString *libraryName;
@property NSURL *website;
@property CGFloat longitude;
@property CGFloat latitude;
@end
