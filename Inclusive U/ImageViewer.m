//
//  ImageViewer.m
//
//  Created by Jeremy Thompson on 9/2/15.
//  Copyright (c) 2015 Jeremy Thompson. All rights reserved.
//

#import "ImageViewer.h"

@interface ImageViewer() <UIScrollViewDelegate>{
    BOOL zoomedIn;
    UIImage *primaryImage;
    UIViewController *viewToPresentIn;
}

@property (strong) UIImageView *imageView;

@end


@implementation ImageViewer
-(id)initWithViewAndImage:(UIViewController *)controller image:(UIImage*)image{
    self = [super init];
    if (self) {
        viewToPresentIn = controller;
        primaryImage = image;
        zoomedIn = FALSE;
    }
    return self;
}

-(void)closeScrollView{
    [self.scrollView removeFromSuperview];
}

-(void)setUpImageAndScrollview{
    CGRect fullScreenFrame = CGRectMake(0, 0, viewToPresentIn.view.frame.size.width, viewToPresentIn.view.frame.size.height);
    self.scrollView = [[UIScrollView alloc] initWithFrame:fullScreenFrame];
    [viewToPresentIn.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.2 green:0.247 blue:0.282 alpha:1];
    
    
    UIButton *button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    button.frame = CGRectMake(5, 10, 40, 50);
    button.tintColor = [UIColor colorWithRed:0.502 green:0.741 blue:1 alpha:1];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeScrollView) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeScrollView)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.scrollView addGestureRecognizer:swipeUp];
    
    //1
    self.imageView = [[UIImageView alloc] initWithImage:primaryImage];
    self.imageView.frame = CGRectMake(0, 0, primaryImage.size.width, primaryImage.size.height);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.imageView];
    
    //2
    self.scrollView.contentSize = primaryImage.size;
    
    // 3
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewWasDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    //4
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    
    //5
    self.scrollView.maximumZoomScale = 1.5;
    self.scrollView.zoomScale = minScale;
    
    //6
    [self centerScrollViewContents];
}


-(void)centerScrollViewContents{
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0;
    }else{
        contentsFrame.origin.x = 0.0;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0;
    }else{
        contentsFrame.origin.y = 0.0;
    }
    self.imageView.frame = contentsFrame;
}


-(void)scrollViewWasDoubleTapped:(UITapGestureRecognizer *)recognizer{
    //1
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    //2
    CGFloat newZoomScale;
    if (zoomedIn) {
        newZoomScale = self.scrollView.minimumZoomScale;
    }else{
        newZoomScale = self.scrollView.maximumZoomScale;
    }
    zoomedIn = !zoomedIn;
    
    //3
    CGSize scrollViewSize = self.scrollView.bounds.size;
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0);
    CGFloat y = pointInView.y - (h / 2.0);
    
    CGRect rectToZoom = CGRectMake(x, y, w, h);
    
    //4
    [self.scrollView zoomToRect:rectToZoom animated:YES];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
}

@end

