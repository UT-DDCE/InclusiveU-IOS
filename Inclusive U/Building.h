//
//  Building.h
//  Inclusive U
//
//  Created by Jeremy Thompson on 8/4/16.
//  Copyright © 2016 Jeremy Thompson. All rights reserved.
//
//
// Building class representing campus buildings and the info for it
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Building : NSObject

// Custom initialization method provided you already have the proper components
-(id)initWithBasics:(NSString *)buildingName code:(NSString *)buildingCode number:(int)numRestrooms rooms:(NSArray *)roomNumbers address:(NSString *)address longitude:(CGFloat)longitude latitude:(CGFloat)latitude link:(NSURL *)imageLink;

// Function for printing out a building (and looking structured) 
-(void)prettyPrint;

// Publicly accessible properties
@property NSString *buildingName;
@property NSString *buildingCode;
@property NSString *bathroomType;
@property int numRestrooms;
@property NSArray *roomNumbers;
@property NSString *buildingAddress;
@property NSString *notes;
@property CGFloat longitude;
@property CGFloat latitude;
@property NSURL *imageLink;
@property CGFloat num;
@end
