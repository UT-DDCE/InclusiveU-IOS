//
//  webViewController.h
//  Inclusive U
//
//  Created by Jeremy Thompson on 12/1/15.
//  Copyright © 2015 Jeremy Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"

@interface webViewController : UIViewController <UIWebViewDelegate, NJKWebViewProgressDelegate>
@property (nonatomic, strong) NSURL *mainURL;
@property (nonatomic) BOOL isFromLibraries;
@property (nonatomic) NSString *buildingName;
@end
