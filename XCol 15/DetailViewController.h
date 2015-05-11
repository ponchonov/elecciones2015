//
//  DetailViewController.h
//  XCol 15
//
//  Created by HECTOR ALFONSO on 25/04/15.
//  Copyright (c) 2015 SHDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Candidato.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *informationWebView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)changeView:(id)sender;
@property (nonatomic, strong) NSArray *candidato;
@property NSInteger selected;
@end
