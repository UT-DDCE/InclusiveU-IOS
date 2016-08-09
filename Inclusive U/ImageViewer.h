//
//  ImageViewer.h
//  Inclusive U
//
//  Created by Jeremy Thompson on 9/2/15.
//  Copyright (c) 2015 Jeremy Thompson. All rights reserved.
//
//  Custom Image Viewer wrapper in order to support zooming of images. 
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageViewer : NSObject

-(id)initWithViewAndImage:(UIViewController *)controller image:(UIImage*)image;
-(void)setUpImageAndScrollview;

@property (strong) UIScrollView *scrollView;
@end
