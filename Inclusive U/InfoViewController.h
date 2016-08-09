//
//  InfoViewController.h
//  PDF_Testing
//
//  Created by Jeremy Thompson on 8/6/15.
//  Copyright (c) 2015 Jeremy Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Building.h"

@interface InfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSDictionary *infoDict;
@property (weak, nonatomic) Building *infoBuilding;

@end
