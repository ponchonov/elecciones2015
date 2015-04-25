//
//  DetailViewController.h
//  XCol 15
//
//  Created by HECTOR ALFONSO on 25/04/15.
//  Copyright (c) 2015 SHDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "candidato.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *informationWebView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic, strong) candidato *candidat;
@end
